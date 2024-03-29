//
//  ApiCore.swift
//  Api6000Components/ApiViewer
//
//  Created by Douglas Adams on 11/24/21.
//

import IdentifiedCollections
import Combine
import SwiftUI

import Api6000
import ClientView
import LoginView
import LogView
import PickerView
import Shared
import SecureStorage
import XCGWrapper

// ----------------------------------------------------------------------------
// MARK: - Structs and Enums

public typealias Logger = (PassthroughSubject<LogEntry, Never>, LogLevel) -> Void

public enum TcpMessageDirection {
  case received
  case sent
}

public struct TcpMessage: Identifiable, Equatable {
  public static func == (lhs: TcpMessage, rhs: TcpMessage) -> Bool {
    lhs.id == rhs.id
  }
  
  public init
  (
    text: String,
    direction: TcpMessageDirection = .received,
    timeInterval: TimeInterval,
    color: Color = .primary
  )
  {
    self.id = UUID()
    self.text = text
    self.direction = direction
    self.timeInterval = timeInterval
    self.color = color
  }
  
  public var id: UUID
  public var text: String
  public var direction: TcpMessageDirection
  public var timeInterval: TimeInterval
  public var color: Color
}

public struct AlertState {
  public var title: String
  public var message: String
}

public struct DefaultValue: Equatable, Codable {
  public var serial: String
  public var source: String
  public var station: String?
  
  public init
  (
    _ serial: String,
    _ source: PacketSource,
    _ station: String?
  )
  {
    self.serial = serial
    self.source = source.rawValue
    self.station = station
  }
  enum CodingKeys: String, CodingKey {
    case source
    case serial
    case station
  }
}

public enum ConnectionMode: String {
  case both
  case local
  case none
  case smartlink
}

public enum ViewType: Equatable {
  case api
  case log
  case remote
}

public enum ObjectFilter: String, CaseIterable {
  case core
  case coreNoMeters = "core w/o meters"
  case amplifiers
  case bandSettings = "band settings"
  case cwx
  case equalizers
  case interlock
  case memories
  case meters
  case profiles
  case streams
  case transmit
  case usbCable
  case wan
  case waveforms
  case xvtrs
}

public enum MessageFilter: String, CaseIterable {
  case all
  case prefix
  case includes
  case excludes
  case command
  case status
  case reply
  case S0
}

@MainActor
public final class ApiModel: ObservableObject {
  // ----------------------------------------------------------------------------
  // MARK: - Properties held in User Defaults

  @AppStorage("isGui") var isGui: Bool = false
  @AppStorage("clearOnStart") var clearOnStart: Bool = false
  @AppStorage("clearOnStop") var clearOnStop: Bool = false
  @AppStorage("clearOnSend") var clearOnSend: Bool = false
  @AppStorage("connectionMode") var connectionMode: String = ConnectionMode.local.rawValue {
    didSet { finishInitialization() }}
  @AppStorage("fontSize") var fontSize: Double = 12
  @AppStorage("forceSmartlinkLogin") public var forceSmartlinkLogin = false
  @AppStorage("messagesFilter") var messageFilter: String = MessageFilter.all.rawValue {
    didSet { filterMessages() }}
  @AppStorage("messageFilterText") var messageFilterText: String = "" {
    didSet { filterMessages() }}
  @AppStorage("objectFilter") var objectFilter: String = ObjectFilter.core.rawValue
  @AppStorage("smartlinkEmail") var smartlinkEmail: String = ""
  @AppStorage("showPings") var showPings: Bool = false
  @AppStorage("showTimes") var showTimes: Bool = false
  @AppStorage("useDefault") var useDefault: Bool = false
  public var guiDefault: DefaultValue?
  {
    set { setDefaultValue(.gui, newValue) }
    get { getDefaultValue(.gui) }}
  public var nonGuiDefault: DefaultValue?
  {
    set { setDefaultValue(.nonGui, newValue) }
    get { getDefaultValue(.nonGui) }}

  // ----------------------------------------------------------------------------
  // MARK: - Published properties

  @Published public var alertModel: AlertModel? { didSet { showAlert = alertModel != nil}}
  @Published public var clearNow = false
  @Published public var clientModel: ClientModel? { didSet { showClient = clientModel != nil}}
  @Published public var commandToSend = ""
  @Published public var isConnected = false
  @Published public var filteredMessages = IdentifiedArrayOf<TcpMessage>()
  @Published public var gotoTop = false
  @Published public var loginModel: LoginModel?
  @Published public var messages = IdentifiedArrayOf<TcpMessage>()
  @Published public var pendingWan: (packet: Packet, station: String?)?
  @Published public var pickerModel: PickerModel? { didSet { showPicker = pickerModel != nil}}
  @Published public var showAlert = false
  @Published public var showClient = false
  @Published public var showLogin = false
  @Published public var showPicker = false

  // ----------------------------------------------------------------------------
  // MARK: - Private properties

  private var _initialized = false
  private var _lanListener: LanListener?
  private var _startTime: Date?
  private var _station: String?
  private var _tcpReceivedTask: Task<(), Never>?
  private var _tcpSentTask: Task<(), Never>?
  private var _wanListener: WanListener?

  private var testSubscription: AnyCancellable?
  private var wanSubscription: AnyCancellable?

  // ----------------------------------------------------------------------------
  // MARK: - Initialization

  public init(isConnected: Bool = false) {
    self.isConnected = isConnected
  }

  // ----------------------------------------------------------------------------
  // MARK: - Internal methods
  
  /// Initialization
  func onAppear() {
    // if the first time, start various effects
    if _initialized == false {
      _initialized = true
      gotoTop = false
      // instantiate the Logger,
      _ = XCGWrapper(logLevel: .debug)
      // start subscriptions
      subscribeToTcpStatus()
      subscribeToUdpStatus()
      subscribeToSent()
      subscribeToReceived()
      subscribeToPackets()
      subscribeToClients()
      subscribeToWan()
      subscribeToLogAlerts()
      
      finishInitialization()
    }
  }
  
  /// Secondary initialization / re-initialization
  func finishInitialization() {
    // needed when coming from other than .onAppear
    _lanListener?.stop()
    _lanListener = nil
    _wanListener?.stop()
    _wanListener = nil
    
    // start / stop listeners as appropriate for the Mode
    switch connectionMode {
    case ConnectionMode.local.rawValue:
      Model.shared.removePackets(condition: {$0.source == .smartlink} )
      _lanListener = LanListener()
      _lanListener!.start()
    
    case ConnectionMode.smartlink.rawValue:
      Model.shared.removePackets(condition: {$0.source == .local} )
      _wanListener = WanListener()
      if forceSmartlinkLogin || _wanListener!.start(smartlinkEmail) == false {
        loginModel = LoginModel(heading: "Smartlink Login required",
                                cancelAction: { self.loginCancel() },
                                loginAction: {user, pwd in self.loginLogin(user, pwd)})
      }

    case ConnectionMode.both.rawValue:
      _lanListener = LanListener()
      _lanListener!.start()
      _wanListener = WanListener()
      if forceSmartlinkLogin || _wanListener!.start(smartlinkEmail) == false {
        loginModel = LoginModel(heading: "Smartlink Login required",
                                cancelAction: { self.loginCancel() },
                                loginAction: {user, pwd in self.loginLogin(user, pwd)})
      }

    case ConnectionMode.none.rawValue:
      Model.shared.removePackets(condition: {$0.source == .local} )
      Model.shared.removePackets(condition: {$0.source == .smartlink} )
      
    default:
      fatalError("Invalid connectionMode")
    }
  }
    
  // ----- Buttons -----
  func startStopButton() {
    // current state?
    if isConnected == false {
      // NOT connected
      if clearOnStart {
        messages.removeAll()
        filteredMessages.removeAll()
      }

      // check for a default
      let (packet, station) = getDefault(isGui)
      if useDefault && packet != nil {
        _station = station
        // YES, is it Wan?
        if packet!.source == .smartlink {
          // YES, reply will generate a wanStatus action
          pendingWan = (packet!, station)
          _wanListener?.sendWanConnectMessage(for: packet!.serial, holePunchPort: packet!.negotiatedHolePunchPort)
          
        } else {
          // NO, check for other connections
          checkConnectionStatus(packet!)
        }
        
      } else {
        // not using default OR no default OR failed to find a match, open the Picker
        pickerModel = PickerModel(
          pickables: getPickables(isGui, guiDefault, nonGuiDefault),
          isGui: isGui,
          defaultId: packet?.id,
          cancelAction: { self.pickerCancel() },
          connectAction: { selection in self.pickerConnect(selection) },
          defaultAction: { selection in self.pickerDefault(selection) },
          testAction: { selection in self.pickerTest(selection) }
        )
      }
      
    } else {
      // CONNECTED, disconnect
      Model.shared.disconnect()
      isConnected = false

      if clearOnStop {
        messages.removeAll()
        filteredMessages.removeAll()
      }
    }
  }

  func clearNowButton() {
    messages.removeAll()
    filteredMessages.removeAll()
  }

  func sendButton() {
    _ = Tcp.shared.send(commandToSend)
    if clearOnSend { commandToSend = "" }
  }

  // ----- Steppers -----
  func fontSizeStepper(_ size: CGFloat) {
    fontSize = size
  }

  // ----------------------------------------------------------------------------
  // MARK: - AlertView Action methods
  
  // subview/sheet/alert related
  func alertDismissed() {
    alertModel = nil
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - PickerView Action methods
  
  func pickerCancel() {
    pickerModel = nil
  }
  
  func pickerDefault(_ selection: PickableSelection ) {
    if let packet = Model.shared.packets[id: selection.packetId] {
      if isGui {
        // YES, gui
        let newValue = DefaultValue(packet.serial, packet.source, nil)
        if guiDefault == newValue {
          guiDefault = nil
          pickerModel?.defaultId = nil
        } else {
          guiDefault = newValue
          pickerModel?.defaultId = selection.packetId
        }
      } else {
        // NO, nonGui
        let newValue =  DefaultValue(packet.serial, packet.source, selection.station)
        if nonGuiDefault == newValue {
          nonGuiDefault = nil
          pickerModel?.defaultId = nil
        } else {
          nonGuiDefault = newValue
          pickerModel?.defaultId = selection.packetId
        }
      }
    }
  }

  func pickerConnect(_ selection: PickableSelection ) {
    pickerModel = nil
    if let packet = Model.shared.packets[id: selection.packetId] {
      // CONNECT, close the Picker sheet
      _station = selection.2
      // is it Smartlink?
      if selection.isLocal == false {
        // YES, send the Wan Connect message
        pendingWan = (packet, _station)
        _wanListener!.sendWanConnectMessage(for: packet.serial, holePunchPort: packet.negotiatedHolePunchPort)
        // the reply to this will generate a wanStatus action
        
      } else {
        // check for other connections
        checkConnectionStatus(packet)
      }
    }
  }
  
  func pickerTest(_ selection: PickableSelection ) {
    if let packet = Model.shared.packets[id: selection.packetId] {
      // TEST BUTTON, send a Test request
      _wanListener!.sendSmartlinkTest(packet.serial)
      // reply will generate a testResult action
      subscribeToTest()
    }
  }

  // ----------------------------------------------------------------------------
  // MARK: - ClientView Action methods
  
  func clientCancel() {
    // CANCEL
    clientModel = nil
  }
  
  func clientConnect(_ id: UUID, _ handle: Handle?) {
    // CONNECT
    clientModel = nil
    if let packet = Model.shared.packets[id: id] {
      openSelection(packet, handle)
    }
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - LoginView Action methods
  
  func loginCancel() {
    loginModel = nil
  }
  
  func loginLogin(_ user: String, _ pwd: String) {
    loginModel = nil
    // save the credentials
    let secureStore = SecureStore(service: "ApiViewer")
    _ = secureStore.set(account: "user", data: user)
    _ = secureStore.set(account: "pwd", data: pwd)
    smartlinkEmail = user
    // try a Smartlink login
    if _wanListener!.start(user: user, pwd: pwd) {
      forceSmartlinkLogin = false
    } else {
      alertModel = AlertModel(title: "Smartlink", message: "Login failed", action: {self.alertDismissed()} )
    }
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - Helper methods
  
  /// Produce an IdentifiedArray of items that can be picked
  /// - Parameter state:  ApiCore state
  /// - Returns:          an array of items that can be picked
  func getPickables(_ isGui: Bool, _ guiDefault: DefaultValue?, _ nonGuiDefault: DefaultValue?) -> IdentifiedArrayOf<Pickable> {
    var pickables = IdentifiedArrayOf<Pickable>()
    if isGui {
      // GUI
      for packet in Model.shared.packets {
        pickables.append( Pickable(id: packet.id,
                                   packetId: packet.id,
                                   isLocal: packet.source == .local,
                                   nickname: packet.nickname,
                                   status: packet.status,
                                   station: packet.guiClientStations,
                                   isDefault: packet.serial == guiDefault?.serial && packet.source.rawValue == guiDefault?.source)
        )
      }
      
    } else {
      // NON-GUI
      for packet in Model.shared.packets {
        for guiClient in packet.guiClients {
          pickables.append( Pickable(id: UUID(),
                                     packetId: packet.id,
                                     isLocal: packet.source == .local,
                                     nickname: packet.nickname,
                                     status: packet.status,
                                     station: guiClient.station,
                                     isDefault: packet.serial == nonGuiDefault?.serial && packet.source.rawValue == nonGuiDefault?.source && packet.guiClientStations == nonGuiDefault?.station)
          )
        }
      }
    }
    return pickables
  }

  // ----------------------------------------------------------------------------
  // MARK: - Subscription related methods
    
  func testResultReceived(_ result: TestNotification) {
    // a test result has been received
    pickerModel?.testResult = result.success
  }
  
  func wanStatusReceived(_ status: WanNotification) {
    // a WanStatus message has been received, was it successful?
    if pendingWan != nil && status.type == .connect && status.wanHandle != nil {
      // YES, set the wan handle
      pendingWan!.packet.wanHandle = status.wanHandle!
      // check for other connections
      checkConnectionStatus(pendingWan!.packet)
    }
  }

  // ----------------------------------------------------------------------------
  // MARK: - Private methods
  
  private func checkConnectionStatus(_ packet: Packet) {
    // making a Gui connection and other Gui connections exist?
    if isGui && packet.guiClients.count > 0 {
      // YES, may need a disconnect, let the user choose
      var stations = [String]()
      var handles = [Handle]()
      for client in packet.guiClients {
        stations.append(client.station)
        handles.append(client.handle)
      }
      clientModel = ClientModel(
        id: packet.id,
        stations: stations,
        handles: handles,
        cancelAction: { self.clientCancel() },
        connectAction: { (id: UUID, handle: UInt32?) in self.clientConnect(id, handle)}
      )

    } else {
      // NO, proceed to opening
      openSelection(packet, nil)
    }
  }

  private func openSelection(_ packet: Packet, _ disconnectHandle: Handle?) {
    isConnected = true
    _startTime = Date()

    // instantiate a Radio object and attempt to connect
    if Model.shared.createRadio(packet: packet, isGui: isGui, disconnectHandle: disconnectHandle, station: "Mac", program: "Api6000Tester", testerMode: true) {
      // connected
      filterMessages()
    } else {
      // failed
      isConnected = false
      alertModel = AlertModel(title: "Connection", message: "Failed to connect to \(packet.nickname)", action: {self.alertDismissed()} )
    }
  }

  /// FIlter the Messages array
  /// - Parameters:
  ///   - state:         the current ApiState
  ///   - filterBy:      the selected filter choice
  ///   - filterText:    the current filter text
  /// - Returns:         a filtered array
  private func filterMessages() {
    // re-filter messages
    switch (messageFilter, messageFilterText) {
      
    case (MessageFilter.all.rawValue, _):        filteredMessages = messages
    case (MessageFilter.prefix.rawValue, ""):    filteredMessages = messages
    case (MessageFilter.prefix.rawValue, _):     filteredMessages = messages.filter { $0.text.localizedCaseInsensitiveContains("|" + messageFilterText) }
    
    case (MessageFilter.includes.rawValue, messageFilterText):   filteredMessages = messages.filter { $0.text.localizedCaseInsensitiveContains(messageFilterText) }
    
    case (MessageFilter.excludes.rawValue, ""):  filteredMessages = messages
    
    case (MessageFilter.excludes.rawValue, messageFilterText):   filteredMessages = messages.filter { !$0.text.localizedCaseInsensitiveContains(messageFilterText) }
    
    case (MessageFilter.command.rawValue, _):    filteredMessages = messages.filter { $0.text.prefix(1) == "C" }
    case (MessageFilter.S0.rawValue, _):         filteredMessages = messages.filter { $0.text.prefix(3) == "S0|" }
    case (MessageFilter.status.rawValue, _):     filteredMessages = messages.filter { $0.text.prefix(1) == "S" && $0.text.prefix(3) != "S0|"}
    case (MessageFilter.reply.rawValue, _):      filteredMessages = messages.filter { $0.text.prefix(1) == "R" }
    default:                                     filteredMessages = messages
    }
  }
  
  /// Read the user defaults entry for a default connection and transform it into a DefaultConnection struct
  /// - Parameters:
  ///    - type:         gui / nonGui
  /// - Returns:         a DefaultValue struct or nil
  private func getDefaultValue(_ type: ConnectionType) -> DefaultValue? {
    let key = type == .gui ? "guiDefault" : "nonGuiDefault"
    
    if let defaultData = UserDefaults.standard.object(forKey: key) as? Data {
      let decoder = JSONDecoder()
      if let defaultValue = try? decoder.decode(DefaultValue.self, from: defaultData) {
        log("ApiModel: \(key) found, \(defaultValue.serial)", .debug, #function, #file, #line)
        return defaultValue
      } else {
        log("ApiModel: \(key) failed to decode", .debug, #function, #file, #line)
        return nil
      }
    }
    log("ApiModel: No \(key) found", .debug, #function, #file, #line)
    return nil
  }
  
  /// Write the user defaults entry for a default connection using a DefaultConnection struct
  /// - Parameters:
  ///    - type:        gui / nonGui
  ///    - value:       a DefaultValue struct  to be encoded and written to user defaults
  private func setDefaultValue(_ type: ConnectionType, _ value: DefaultValue?) {
    let key = type == .gui ? "guiDefault" : "nonGuiDefault"
    
    if value == nil {
      UserDefaults.standard.removeObject(forKey: key)
      log("ApiModel: Default removed", .debug, #function, #file, #line)
    } else {
      let encoder = JSONEncoder()
      if let encoded = try? encoder.encode(value) {
        UserDefaults.standard.set(encoded, forKey: key)
        log("ApiModel: Default save", .debug, #function, #file , #line)
      } else {
        UserDefaults.standard.removeObject(forKey: key)
        log("ApiModel: Default save failed", .debug, #function, #file, #line)
      }
    }
  }
  
  /// Determine if there is default radio connection
  /// - Parameter state:  ApiCore state
  /// - Returns:          a tuple of the Packet and an optional Station
  private func getDefault(_ isGui: Bool) -> (Packet?, String?) {
    if isGui {
      if let defaultValue = guiDefault {
        for packet in Model.shared.packets where defaultValue.source == packet.source.rawValue && defaultValue.serial == packet.serial {
          // found one
          return (packet, nil)
        }
      }
    } else {
      if let defaultValue = nonGuiDefault {
        for packet in Model.shared.packets where defaultValue.source == packet.source.rawValue && defaultValue.serial == packet.serial  && packet.guiClientStations.contains(defaultValue.station!){
          // found one
          return (packet, defaultValue.station)
        }
      }
    }
    // NO default or failed to find a match
    return (nil, nil)
  }

  // ----------------------------------------------------------------------------
  // MARK: - Private (subscriptions)
  
  private func subscribeToPackets() {
    Task {
//      print("----------> subscribeToPackets: STARTED")
      for await _ in Model.shared.packetUpdate {
        // a packet change has been observed
        if pickerModel != nil {
          pickerModel!.pickables = getPickables(isGui, guiDefault, nonGuiDefault)
        }
      }
//      print("-----> subscribeToPackets: STOPPED")
    }
  }
  
  private func subscribeToClients() {
    Task {
//      print("----------> subscribeToClients: STARTED")
      for await update in Model.shared.clientUpdate {
        // a guiClient change has been observed
        switch update.action {
        case .added, .deleted:  break
        
        case .completed:
          if isConnected && isGui == false {
            // YES, is there a clientId for our connected Station?
            if update.client.clientId != nil && update.client.station == _station {
              // YES, bind to it
              Model.shared.radio?.bindToGuiClient(update.client.clientId)
              Model.shared.activeStation = _station
            }
          }
        }
      }
//      print("-----> subscribeToClients: STOPPED")
    }
  }
  
  private func subscribeToTcpStatus() {
    Task {
//      print("----------> subscribeToTcpStatus: STARTED")
      for await status in Tcp.shared.tcpStatus {
        // pass them to the API
        Model.shared.radio?.tcpStatus(status)
      }
//      print("-----> subscribeToTcpStatus: STOPPED")
    }
  }

  public func subscribeToUdpStatus() {
    Task {
//      print("----------> subscribeToUdpStatus: STARTED")
      for await status in Udp.shared.udpStatus {
        Model.shared.radio?.udpStatus(status)
      }
//      print("-----> subscribeToUdpStatus: STOPPED")
    }
  }

  private func subscribeToSent() {
    _tcpSentTask = Task {
//      print("----------> subscribeToSent: STARTED")
      // process the AsyncStream of Tcp messages sent to the Radio
      for await message in Tcp.shared.tcpOutbound {

        // ignore sent "ping" messages unless showPings is true
        if message.contains("ping") && showPings == false { continue }

        // convert to TcpMessage format, add to the collection and refilter
        let tcpMessage = TcpMessage(text: message, direction: .sent, timeInterval: Date().timeIntervalSince( _startTime!))
        messages.append( tcpMessage )
        filterMessages()
      }
//      print("-----> subscribeToSent: STOPPED")
    }
  }
  private func unSubscribeToSent() {
    _tcpSentTask?.cancel()
  }

  private func subscribeToReceived() {
    _tcpReceivedTask = Task {
//      print("----------> subscribeToReceived: STARTED")
      // process the AsyncStream of Tcp messages sent from the Radio
      for await message in Tcp.shared.tcpInbound {
       
        // pass them to the API
        Model.shared.radio?.tcpInbound(message)
        
        // ignore reply unless it is non-zero or contains additional data
        if ignoreReply(message) { continue }

        // convert to TcpMessage format, add to the collection and refilter
        let tcpMessage = TcpMessage(text: message, direction: .received, timeInterval: Date().timeIntervalSince( _startTime!))
        messages.append( tcpMessage )
        filterMessages()
      }
//      print("-----> subscribeToReceived: STOPPED")
    }
  }
  private func unSubscribeToReceived() {
    _tcpReceivedTask?.cancel()
  }

  private func subscribeToWan() {
    // subscribe to the publisher of Wan messages
   wanSubscription = NotificationCenter.default.publisher(for: wanNotification, object: nil)
      .receive(on: DispatchQueue.main)
      .sink { [self] note in
        wanStatusReceived( note.object as! WanNotification )
      }
  }

  private func subscribeToTest() {
    // subscribe to the publisher of Smartlink test results
    testSubscription = NotificationCenter.default.publisher(for: testNotification, object: nil)
      .receive(on: DispatchQueue.main)
      .sink { [self] note in
        testResultReceived( note.object as! TestNotification)
      }
  }

  private func subscribeToLogAlerts() {
    #if DEBUG
    Task {
//      print("----------> subscribeToLogAlerts: STARTED")
      for await entry in logAlerts {
        // a Warning or Error has been logged.
        // exit any sheet states
        pickerModel = nil
        loginModel = nil
        // alert the user
        alertModel = AlertModel(title: "\(entry.level == .warning ? "A Warning" : "An Error") was logged",
                                message: entry.msg,
                                action: {self.alertDismissed()} )
      }
//      print("-----> subscribeToLogAlerts: STOPPED")
    }
    #endif
  }

  /// Received data Filter condition
  /// - Parameter text:    the text of a received command
  /// - Returns:           a boolean
  private func ignoreReply(_ text: String) -> Bool {
    if text.first != "R" { return false }     // not a Reply
    let parts = text.components(separatedBy: "|")
    if parts.count < 3 { return false }       // incomplete
    if parts[1] != kNoError { return false }  // error of some type
    if parts[2] != "" { return false }        // additional data present
    return true                               // otherwise, ignore it
  }

}
