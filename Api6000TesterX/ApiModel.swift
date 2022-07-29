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
  case interlock
  case memories
  case meters
  case streams
  case transmit
  case tnfs
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

public class ApiModel: ObservableObject {
  // ----------------------------------------------------------------------------
  // MARK: - Properties held in User Defaults

  @AppStorage("isGui") var isGui: Bool = false
  @AppStorage("clearOnStart") var clearOnStart: Bool = false
  @AppStorage("clearOnStop") var clearOnStop: Bool = false
  @AppStorage("clearOnSend") var clearOnSend: Bool = false
  @AppStorage("connectionMode") var connectionMode: String = ConnectionMode.local.rawValue {
    didSet { Task { await finishInitialization() }}}
  @AppStorage("fontSize") var fontSize: Double = 12
  @AppStorage("messagesFilter") var messageFilter: String = MessageFilter.all.rawValue {
    didSet { Task { await filterMessages() }}}
  @AppStorage("messageFilterText") var messageFilterText: String = "" {
    didSet { Task { await filterMessages() }}}
  @AppStorage("objectFilter") var objectFilter: String = ObjectFilter.core.rawValue
  @AppStorage("smartlinkEmail") var smartlinkEmail: String = ""
  @AppStorage("showPings") var showPings: Bool = false
  @AppStorage("showTimes") var showTimes: Bool = false
  @AppStorage("useDefault") var useDefault: Bool = false
  public var guiDefault: DefaultValue? { didSet { setDefaultValue(.gui, guiDefault) } }
  public var nonGuiDefault: DefaultValue? { didSet { setDefaultValue(.nonGui, nonGuiDefault) } }

  // ----------------------------------------------------------------------------
  // MARK: - Published properties

  @Published public var alertState: AlertState? = nil
  @Published public var clearNow = false
  @Published public var clientModel: ClientModel?
  @Published public var commandToSend = ""
  @Published public var isConnected = false
  @Published public var filteredMessages = IdentifiedArrayOf<TcpMessage>()
  @Published public var forceWanLogin = false
  @Published public var loginModel: LoginModel? = nil
  @Published public var messages = IdentifiedArrayOf<TcpMessage>()
  @Published public var pendingWan: (packet: Packet, station: String?)? = nil
  @Published public var pickerModel: PickerModel? = nil
  @Published public var showClient = false
  @Published public var showLogin = false
  @Published public var showPicker = false
  @Published public var showProgress = false
  @Published public var gotoTop = false

  @Published public var forceUpdate = false

  // ----------------------------------------------------------------------------
  // MARK: - Private properties

  private var initialized = false
  private var lanListener: LanListener? = nil
  private var station: String? = nil
  private var wanListener: WanListener? = nil

  private var clientSubscription: AnyCancellable?
  private var logAlertSubscription: AnyCancellable?
  private var meterSubscription: AnyCancellable?
  private var packetSubscription: AnyCancellable?
  private var receivedSubscription: AnyCancellable?
  private var sentSubscription: AnyCancellable?
  private var testSubscription: AnyCancellable?
  private var wanSubscription: AnyCancellable?

  // ----------------------------------------------------------------------------
  // MARK: - Initialization

  public init()
  {
    self.guiDefault = getDefaultValue(.gui)
    self.nonGuiDefault = getDefaultValue(.nonGui)
  }

  // ----------------------------------------------------------------------------
  // MARK: - Internal methods
  
  /// Initialization
  @MainActor func onAppear() {
    // if the first time, start various effects
    if initialized == false {
      initialized = true
      gotoTop = false
      // instantiate the Logger,
      _ = XCGWrapper(logLevel: .debug)
      // start subscriptions
      subscribeToPackets()
      subscribeToWan()
      subscribeToSent(Tcp.shared)
      subscribeToReceived(Tcp.shared)
      subscribeToLogAlerts()
      
      finishInitialization()
    }
  }
  
  /// Secondary initialization / re-initialization
  @MainActor func finishInitialization() {
    // needed when coming from other than .onAppear
    lanListener?.stop()
    lanListener = nil
    wanListener?.stop()
    wanListener = nil
    
    // start / stop listeners as appropriate for the Mode
    switch connectionMode {
    case ConnectionMode.local.rawValue:
      Model.shared.removePackets(condition: {$0.source == .smartlink} )
      lanListener = LanListener()
      lanListener!.start()
    case ConnectionMode.smartlink.rawValue:
      Model.shared.removePackets(condition: {$0.source == .local} )
      wanListener = WanListener()
      if forceWanLogin || wanListener!.start(smartlinkEmail) == false {
        loginModel = LoginModel(heading: "Smartlink Login required",
                                cancelAction: { self.loginCancel() },
                                loginAction: {user, pwd in self.loginLogin(user, pwd)})
        showLogin = true
      }
    case ConnectionMode.both.rawValue:
      lanListener = LanListener()
      lanListener!.start()
      wanListener = WanListener()
      if forceWanLogin || wanListener!.start(smartlinkEmail) == false {
        loginModel = LoginModel(heading: "Smartlink Login required",
                                cancelAction: { self.loginCancel() },
                                loginAction: {user, pwd in self.loginLogin(user, pwd)})
        showLogin = true
      }
    case ConnectionMode.none.rawValue:
      Model.shared.removePackets(condition: {$0.source == .local} )
      Model.shared.removePackets(condition: {$0.source == .smartlink} )
    default:
      fatalError("Invalid connectionMode")
    }
    // subscribe to meters as needed
    if objectFilter == ObjectFilter.core.rawValue || objectFilter == ObjectFilter.meters.rawValue {
      subscribeToMeters()
    }
  }
    
  // ----- Buttons -----
  @MainActor func startStopButton() {
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
        // YES, is it Wan?
        if packet!.source == .smartlink {
          // YES, reply will generate a wanStatus action
          pendingWan = (packet!, station)
          wanListener?.sendWanConnectMessage(for: packet!.serial, holePunchPort: packet!.negotiatedHolePunchPort)
          
        } else {
          // NO, check for other connections
          checkConnectionStatus(packet!)
        }
        
      } else {
        // not using default OR no default OR failed to find a match, open the Picker
        pickerModel = PickerModel(
          pickables: getPickables(isGui, nil, nil),
          defaultId: packet?.id,
          cancelAction: { self.pickerCancel() },
          connectAction: { id in self.pickerConnect(id) },
          defaultAction: { id in self.pickerDefault(id) },
          testAction: { id in self.pickerTest(id) }
        )
        showPicker = true
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

  // ----- Pickers -----
  @MainActor func connectionModePicker(_ mode: ConnectionMode) {
    connectionMode = mode.rawValue
    finishInitialization()
  }
  
  @MainActor func messagesPicker(_ filter: MessageFilter) {
    messageFilter = filter.rawValue
    // re-filter
    filterMessages()
  }

  @MainActor func objectsPicker(_ newFilter: String) {
    switch (objectFilter, newFilter) {
    case ("core", "meters"), ("meters", "core"):  break
    case ("core", _), ("meters", _):              meterSubscription = nil
    case (_, "core"), (_, "meters"):              subscribeToMeters()
    default:                                      break
    }
    objectFilter = newFilter
  }

  // ----- Steppers -----
  func fontSizeStepper(_ size: CGFloat) {
    fontSize = size
  }

  // ----------------------------------------------------------------------------
  // MARK: - Alert Action methods
  
  // subview/sheet/alert related
  func alertDismissed() {
    alertState = nil
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - Picker Action methods
  
  @MainActor func pickerCancel() {
    showPicker = false
    pickerModel = nil
  }
  
  @MainActor func pickerDefault(_ id: UUID) {
    if let packetId = pickerModel?.pickables[id: id]?.packetId {
      if let packet = Model.shared.packets[id: packetId] {
        if isGui {
          // YES, gui
          let newValue = DefaultValue(packet.serial, packet.source, nil)
          if guiDefault == newValue {
            guiDefault = nil
            pickerModel?.defaultId = nil
          } else {
            guiDefault = newValue
            pickerModel?.defaultId = id
          }
        } else {
          // NO, nonGui
          let newValue =  DefaultValue(packet.serial, packet.source, pickerModel!.pickables[id: id]!.station)
          if nonGuiDefault == newValue {
            nonGuiDefault = nil
          } else {
            nonGuiDefault = newValue
          }
        }
      }
    }
  }

  @MainActor func pickerConnect(_ id: UUID, station: String? = nil) {
    showPicker = false
    pickerModel = nil
    if let packet = Model.shared.packets[id: id] {
      // CONNECT, close the Picker sheet
      self.station = station
      // is it Smartlink?
      if packet.source == .smartlink {
        // YES, send the Wan Connect message
        pendingWan = (packet, station)
        wanListener!.sendWanConnectMessage(for: packet.serial, holePunchPort: packet.negotiatedHolePunchPort)
        // the reply to this will generate a wanStatus action
        
      } else {
        // check for other connections
        checkConnectionStatus(packet)
      }
    }
  }
  
  @MainActor func pickerTest(_ id: UUID) {
    if let packetId = pickerModel?.pickables[id: id]?.packetId {
      if let packet = Model.shared.packets[id: packetId] {
        // TEST BUTTON, send a Test request
        wanListener!.sendSmartlinkTest(packet.serial)
        // reply will generate a testResult action
        subscribeToTest()
      }
    }
  }

  // ----------------------------------------------------------------------------
  // MARK: - Client Action methods
  
  @MainActor func clientCancel() {
    // CANCEL
    showClient = false
    clientModel = nil
  }
  
  @MainActor func clientConnect(_ id: UUID, _ handle: Handle?) {
    // CONNECT
    showClient = false
    clientModel = nil
    if let packet = Model.shared.packets[id: id] {
      openSelection(packet, handle)
    }
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - LoginView Action methods
  
  func loginCancel() {
    showLogin = false
    loginModel = nil
  }
  
  func loginLogin(_ user: String, _ pwd: String) {
    showLogin = false
    loginModel = nil
    // save the credentials
    let secureStore = SecureStore(service: "ApiViewer")
    _ = secureStore.set(account: "user", data: user)
    _ = secureStore.set(account: "pwd", data: pwd)
    smartlinkEmail = user
    // try a Smartlink login
    if wanListener!.start(user: user, pwd: pwd) {
      forceWanLogin = false
    } else {
      alertState = AlertState(title: "Smartlink", message: "Login failed")
    }
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - Helper methods
  

  /// Produce an IdentifiedArray of items that can be picked
  /// - Parameter state:  ApiCore state
  /// - Returns:          an array of items that can be picked
  @MainActor func getPickables(_ isGui: Bool, _ guiDefault: DefaultValue?, _ nonGuiDefault: DefaultValue?) -> IdentifiedArrayOf<Pickable> {
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
  
  func cancelSubscriptions() {
    logAlertSubscription = nil
    sentSubscription = nil
    receivedSubscription = nil
    meterSubscription = nil
  }
  
  func logAlertReceived(_ entry: LogEntry) {
    // a Warning or Error has been logged.
    // exit any sheet states
    pickerModel = nil
    showPicker = false
    loginModel = nil
    showLogin = false
    // alert the user
    alertState = AlertState(title: "\(entry.level == .warning ? "A Warning" : "An Error") was logged:",
                            message: entry.msg)
    
  }
  
  @MainActor func messageSent(_ message: TcpMessage) {
    // ignore sent "ping" messages unless showPings is true
    if message.text.contains("ping") && showPings == false { return }
    // add the message to the collection
    messages.append( message )
    // re-filter
    filterMessages()
  }
  
  @MainActor func messageReceived(_ message: TcpMessage) {
    // add the message to the collection
    messages.append( message )
    // re-filter
    filterMessages()
  }
  
  func meterReceived(_ meter: Meter) {
    // an updated meter value has been received
    forceUpdate.toggle()
  }
  
  func clientReceived(_ update: ClientNotification) {
    // a guiClient change has been observed
    switch update.action {
    case .added:
//      if isConnected && isGui == false {
//        // YES, is there a clientId for our connected Station?
//        if update.client.clientId != nil && update.client.station == station {
//          // YES, bind to it
//          Task {
//            await Model.shared.radio?.bindToGuiClient(update.client.clientId)
//          }
//        }
//      }
    break
    
    case .completed:
      if isConnected && isGui == false {
        // YES, is there a clientId for our connected Station?
        if update.client.clientId != nil && update.client.station == station {
          // YES, bind to it
          Task {
            await Model.shared.radio?.bindToGuiClient(update.client.clientId)
          }
        }
      }
    case .deleted:
      forceUpdate.toggle()
    }
  }
  
  @MainActor func packetReceived(_ update: PacketNotification) {
//    switch update.action {
//    case .added:
//    case .updated:
//    case .deleted:
//    }
    // a packet change has been observed
    if pickerModel != nil {
      pickerModel!.pickables = getPickables(isGui, guiDefault, nonGuiDefault)
    }
    forceUpdate.toggle()
  }
  
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
      Task { await checkConnectionStatus(pendingWan!.packet) }
    }
  }

  // ----------------------------------------------------------------------------
  // MARK: - Private methods
  
  @MainActor private func checkConnectionStatus(_ packet: Packet) {
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
      showClient = true
      

    } else {
      // NO, proceed to opening
      openSelection(packet, nil)
    }
  }

  private func openSelection(_ packet: Packet, _ disconnectHandle: Handle?) {
    isConnected = true
    Task {
      // instantiate a Radio object and attempt to connect
      if await Model.shared.createRadio(packet: packet, isGui: isGui, disconnectHandle: disconnectHandle, station: "Mac", program: "Api6000Tester", testerMode: true) {
        // connected
        await filterMessages()
      } else {
        // failed
        isConnected = false
        alertState = AlertState(title: "Connection", message: "Failed to connect to \(packet.nickname)")
      }
    }
  }

  /// FIlter the Messages array
  /// - Parameters:
  ///   - state:         the current ApiState
  ///   - filterBy:      the selected filter choice
  ///   - filterText:    the current filter text
  /// - Returns:         a filtered array
  @MainActor private func filterMessages() {    
    // re-filter messages
    switch (messageFilter, messageFilterText) {
      
    case (MessageFilter.all.rawValue, _):        filteredMessages = messages
    case (MessageFilter.prefix.rawValue, ""):    filteredMessages = messages
    case (MessageFilter.prefix.rawValue, _):     filteredMessages = messages.filter { $0.text.localizedCaseInsensitiveContains("|" + messageFilterText) }
    case (MessageFilter.includes.rawValue, _):   filteredMessages = messages.filter { $0.text.localizedCaseInsensitiveContains(messageFilterText) }
    case (MessageFilter.excludes.rawValue, ""):  filteredMessages = messages
    case (MessageFilter.excludes.rawValue, _):   filteredMessages = messages.filter { !$0.text.localizedCaseInsensitiveContains(messageFilterText) }
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
        return defaultValue
      } else {
        return nil
      }
    }
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
    } else {
      let encoder = JSONEncoder()
      if let encoded = try? encoder.encode(value) {
        UserDefaults.standard.set(encoded, forKey: key)
      } else {
        UserDefaults.standard.removeObject(forKey: key)
      }
    }
  }
  
  /// Determine if there is default radio connection
  /// - Parameter state:  ApiCore state
  /// - Returns:          a tuple of the Packet and an optional Station
  @MainActor private func getDefault(_ isGui: Bool) -> (Packet?, String?) {
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
  // MARK: - Private subscription setup methods
  
  @MainActor private func subscribeToPackets() {
    // subscribe to the publisher of packet changes
    packetSubscription = NotificationCenter.default.publisher(for: packetNotification, object: nil)
//      .receive(on: DispatchQueue.main)
      .sink { [self] note in
        packetReceived( note.object as! PacketNotification )
      }
    
    // subscribe to the publisher of guiClient changes
    clientSubscription = NotificationCenter.default.publisher(for: clientNotification, object: nil)
//      .receive(on: DispatchQueue.main)
      .sink { [self] note in
        clientReceived( note.object as! ClientNotification )
      }
  }
  
  private func subscribeToSent(_ tcp: Tcp) {
    // subscribe to the publisher of sent TcpMessages
    sentSubscription = tcp.sentPublisher
//      .receive(on: DispatchQueue.main)
      .sink { [self] message in
        Task { await messageSent( message ) }
      }
  }
  
  private func subscribeToReceived(_ tcp: Tcp) {
    // subscribe to the publisher of received TcpMessages
    receivedSubscription = tcp.receivedPublisher
      // eliminate replies unless they have errors or data
      .filter { self.allowToPass($0.text) }
//      .receive(on: DispatchQueue.main)
      .sink { [self] message in
        Task { await messageReceived( message ) }
      }
  }

  @MainActor private func subscribeToMeters() {
    // subscribe to the publisher of meter value updates
    meterSubscription = Meter.meterPublisher
//      .receive(on: DispatchQueue.main)
      // limit updates to 1 per second
      .throttle(for: 1.0, scheduler: RunLoop.main, latest: true)
      // convert to an ApiAction
      .sink { [self] meter in
        meterReceived( meter )
      }
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
    // subscribe to the publisher of LogEntries with Warning or Error levels
    logAlertSubscription = NotificationCenter.default.publisher(for: logAlertNotification, object: nil)
      .receive(on: DispatchQueue.main)
      // convert to an ApiAction
      .sink { [self] note in
        logAlertReceived( note.object as! LogEntry )
      }
    #else
      .none
    #endif
  }

  /// Received data Filter condition
  /// - Parameter text:    the text of a received command
  /// - Returns:           a boolean
  private func allowToPass(_ text: String) -> Bool {
    if text.first != "R" { return true }      // pass if not a Reply
    let parts = text.components(separatedBy: "|")
    if parts.count < 3 { return true }        // pass if incomplete
    if parts[1] != kNoError { return true }   // pass if error of some type
    if parts[2] != "" { return true }         // pass if additional data present
    return false                              // otherwise, filter out (i.e. don't pass)
  }

}