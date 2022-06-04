//
//  ApiCore.swift
//  Components6000/ApiViewer
//
//  Created by Douglas Adams on 11/24/21.
//

import Combine
import ComposableArchitecture
import Dispatch
import SwiftUI

import Api6000
import ClientView
import LoginView
import LogView
import PickerView
import RemoteView
import Shared
import SecureStorage
import TcpCommands
import UdpStreams
import XCGWrapper

// ----------------------------------------------------------------------------
// MARK: - Structs and Enums

public typealias Logger = (PassthroughSubject<LogEntry, Never>, LogLevel) -> Void

public struct TcpMessage: Equatable, Identifiable {
  public var id = UUID()
  var direction: TcpMessageDirection
  var text: String
  var color: Color
  var timeInterval: TimeInterval
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

public enum ObjectsFilter: String, CaseIterable {
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

public enum MessagesFilter: String, CaseIterable {
  case all
  case prefix
  case includes
  case excludes
  case command
  case status
  case reply
  case S0
}

// ----------------------------------------------------------------------------
// MARK: - State, Actions & Environment

public struct ApiState: Equatable {  
  // State held in User Defaults
  public var clearOnConnect: Bool { didSet { UserDefaults.standard.set(clearOnConnect, forKey: "clearOnConnect") } }
  public var clearOnDisconnect: Bool { didSet { UserDefaults.standard.set(clearOnDisconnect, forKey: "clearOnDisconnect") } }
  public var clearOnSend: Bool { didSet { UserDefaults.standard.set(clearOnSend, forKey: "clearOnSend") } }
  public var connectionMode: ConnectionMode { didSet { UserDefaults.standard.set(connectionMode.rawValue, forKey: "connectionMode") } }
  public var guiDefault: DefaultValue? { didSet { setDefaultValue(.gui, guiDefault) } }
  public var nonGuiDefault: DefaultValue? { didSet { setDefaultValue(.nonGui, nonGuiDefault) } }
  public var fontSize: CGFloat { didSet { UserDefaults.standard.set(fontSize, forKey: "fontSize") } }
  public var isGui: Bool { didSet { UserDefaults.standard.set(isGui, forKey: "isGui") } }
  public var messagesFilterBy: MessagesFilter { didSet { UserDefaults.standard.set(messagesFilterBy.rawValue, forKey: "messagesFilterBy") } }
  public var messagesFilterByText: String { didSet { UserDefaults.standard.set(messagesFilterByText, forKey: "messagesFilterByText") } }
  public var objectsFilterBy: ObjectsFilter { didSet { UserDefaults.standard.set(objectsFilterBy.rawValue, forKey: "objectsFilterBy") } }
  public var showPings: Bool { didSet { UserDefaults.standard.set(showPings, forKey: "showPings") } }
  public var showTimes: Bool { didSet { UserDefaults.standard.set(showTimes, forKey: "showTimes") } }
  public var smartlinkEmail: String { didSet { UserDefaults.standard.set(smartlinkEmail, forKey: "smartlinkEmail") } }
  public var useDefault: Bool { didSet { UserDefaults.standard.set(useDefault, forKey: "useDefault") } }
  
  // normal state
  public var alert: AlertState<ApiAction>?
  public var clearNow = false
  public var clientState: ClientState?
  public var commandToSend = ""
  public var initialized = false
  public var lanListener: LanListener?
  public var wanListener: WanListener?
  public var filteredMessages = IdentifiedArrayOf<TcpMessage>()
  public var forceWanLogin = false
  public var forceUpdate = false
  public var loginState: LoginState? = nil
  public var messages = IdentifiedArrayOf<TcpMessage>()
  public var model = Model.shared
  public var pendingWanId: UUID?
  public var pickerState: PickerState? = nil
  public var radio: Radio?
  public var reverseLog = false
  public var station: String? = nil
  public var tcp = Tcp()
  
  public init(
    clearOnConnect: Bool = UserDefaults.standard.bool(forKey: "clearOnConnect"),
    clearOnDisconnect: Bool  = UserDefaults.standard.bool(forKey: "clearOnDisconnect"),
    clearOnSend: Bool  = UserDefaults.standard.bool(forKey: "clearOnSend"),
    connectionMode: ConnectionMode = ConnectionMode(rawValue: UserDefaults.standard.string(forKey: "connectionMode") ?? "local") ?? .local,
    guiDefault: DefaultValue? = getDefaultValue(.gui),
    nonGuiDefault: DefaultValue? = getDefaultValue(.nonGui),
    fontSize: CGFloat = UserDefaults.standard.double(forKey: "fontSize") == 0 ? 12 : UserDefaults.standard.double(forKey: "fontSize"),
    isGui: Bool = UserDefaults.standard.bool(forKey: "isGui"),
    messagesFilterBy: MessagesFilter = MessagesFilter(rawValue: UserDefaults.standard.string(forKey: "messagesFilterBy") ?? "all") ?? .all,
    messagesFilterByText: String = UserDefaults.standard.string(forKey: "messagesFilterByText") ?? "",
    objectsFilterBy: ObjectsFilter = ObjectsFilter(rawValue: UserDefaults.standard.string(forKey: "objectsFilterBy") ?? "core") ?? .core,
    radio: Radio? = nil,
    showPings: Bool = UserDefaults.standard.bool(forKey: "showPings"),
    showTimes: Bool = UserDefaults.standard.bool(forKey: "showTimes"),
    smartlinkEmail: String = UserDefaults.standard.string(forKey: "smartlinkEmail") ?? "",
    useDefault: Bool = UserDefaults.standard.bool(forKey: "useDefault")
  )
  {
    self.clearOnConnect = clearOnConnect
    self.clearOnDisconnect = clearOnDisconnect
    self.clearOnSend = clearOnSend
    self.connectionMode = connectionMode
    self.guiDefault = guiDefault
    self.nonGuiDefault = nonGuiDefault
    self.fontSize = fontSize
    self.isGui = isGui
    self.messagesFilterBy = messagesFilterBy
    self.messagesFilterByText = messagesFilterByText
    self.objectsFilterBy = objectsFilterBy
    self.radio = radio
    self.showPings = showPings
    self.showTimes = showTimes
    self.smartlinkEmail = smartlinkEmail
    self.useDefault = useDefault
  }
}

public enum ApiAction: Equatable {
  // initialization
  case onAppear
  
  // UI controls
  case clearDefaultButton
  case clearNowButton
  case commandTextField(String)
  case connectionModePicker(ConnectionMode)
  case fontSizeStepper(CGFloat)
  case messagesPicker(MessagesFilter)
  case messagesFilterTextField(String)
  case objectsPicker(ObjectsFilter)
  case sendButton
  case startStopButton
  case toggle(WritableKeyPath<ApiState, Bool>)
  
  // subview/sheet/alert related
  case alertDismissed
  case clientAction(ClientAction)
  case loginAction(LoginAction)
  case pickerAction(PickerAction)
  
  // Effects related
  case cancelEffects
  case checkConnectionStatus(UUID)
  case clientChangeReceived(ClientUpdate)
  case finishInitialization
  case logAlertReceived(LogEntry)
  case meterReceived(Meter)
  case openSelection(UUID, Handle?)
  case packetChangeReceived(PacketUpdate)
  case testResult(SmartlinkTestResult)
  case tcpMessage(TcpMessage)
  case wanStatus(WanStatus)
}

public struct ApiEnvironment {
  public init(
    queue: @escaping () -> AnySchedulerOf<DispatchQueue> = { .main }
    //    logger: @escaping Logger = { _ = XCGWrapper($0, logLevel: $1) }
  )
  {
    self.queue = queue
    //    self.logger = logger
  }
  
  var queue: () -> AnySchedulerOf<DispatchQueue>
  //  var logger: Logger
}

// ----------------------------------------------------------------------------
// MARK: - Reducer

public let apiReducer = Reducer<ApiState, ApiAction, ApiEnvironment>.combine(
  clientReducer
    .optional()
    .pullback(
      state: \ApiState.clientState,
      action: /ApiAction.clientAction,
      environment: { _ in ClientEnvironment() }
    ),
  loginReducer
    .optional()
    .pullback(
      state: \ApiState.loginState,
      action: /ApiAction.loginAction,
      environment: { _ in LoginEnvironment() }
    ),
  pickerReducer
    .optional()
    .pullback(
      state: \ApiState.pickerState,
      action: /ApiAction.pickerAction,
      environment: { _ in PickerEnvironment() }
    ),
  Reducer { state, action, environment in
    
    switch action {
      // ----------------------------------------------------------------------------
      // MARK: - Actions: Initialization
      
    case .onAppear:
      // if the first time, start various effects
      if state.initialized == false {
        state.initialized = true
        // instantiate the Logger,
        _ = XCGWrapper(logLevel: .debug)
        //        _ = environment.logger(LogProxy.sharedInstance.logPublisher, .debug)
        // start subscriptions
        return .merge(
          subscribeToPackets(),
          subscribeToWan(),
          subscribeToSent(state.tcp),
          subscribeToReceived(state.tcp),
          subscribeToLogAlerts(),
          Effect(value: .finishInitialization))
      }
      return .none
      
    case .finishInitialization:
      // needed when coming from other than .onAppear
      state.lanListener?.stop()
      state.lanListener = nil
      state.wanListener?.stop()
      state.wanListener = nil
      
      // start / stop listeners as appropriate for the Mode
      switch state.connectionMode {
      case .local:
        state.model.removePackets(ofType: .smartlink)
        state.lanListener = LanListener()
        state.lanListener!.start()
      case .smartlink:
        state.model.removePackets(ofType: .local)
        state.wanListener = WanListener()
        if state.forceWanLogin || state.wanListener!.start(state.smartlinkEmail) == false {
          state.loginState = LoginState(heading: "Smartlink Login required")
        }
      case .both:
        state.lanListener = LanListener()
        state.lanListener!.start()
        state.wanListener = WanListener()
        if state.forceWanLogin || state.wanListener!.start(state.smartlinkEmail) == false {
          state.loginState = LoginState(heading: "Smartlink Login required")
        }
      case .none:
        state.model.removePackets(ofType: .local)
        state.model.removePackets(ofType: .smartlink)
      }
      // subscribe to meters as needed
      if state.objectsFilterBy == .core || state.objectsFilterBy == .meters {
        return subscribeToMeters()
      }
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Actions: ApiView UI
      
    case .clearDefaultButton:
      if state.isGui {
        state.guiDefault = nil
      } else {
        state.nonGuiDefault = nil
      }
      return .none
      
    case .clearNowButton:
      state.messages.removeAll()
      state.filteredMessages.removeAll()
      return .none
      
    case .commandTextField(let text):
      state.commandToSend = text
      return .none
      
    case .connectionModePicker(let mode):
      state.connectionMode = mode
      return Effect(value: .finishInitialization)
      
    case .fontSizeStepper(let size):
      state.fontSize = size
      return .none
      
    case .messagesPicker(let filter):
      state.messagesFilterBy = filter
      // re-filter
      state.filteredMessages = filterMessages(state, state.messagesFilterBy, state.messagesFilterByText)
      return .none
      
    case .messagesFilterTextField(let text):
      state.messagesFilterByText = text
      // re-filter
      state.filteredMessages = filterMessages(state, state.messagesFilterBy, state.messagesFilterByText)
      return .none
      
    case .objectsPicker(let newFilterBy):
      let prevObjectsFilterBy = state.objectsFilterBy
      state.objectsFilterBy = newFilterBy
      
      switch (prevObjectsFilterBy, newFilterBy) {
      case (.core, .meters), (.meters, .core):  return .none
      case (.core, _), (.meters, _):            return .cancel(id: MeterSubscriptionId())
      case (_, .core), (_, .meters):            return subscribeToMeters()
      default:                                  return .none
      }
      
    case .sendButton:
      _ = state.tcp.send(state.commandToSend)
      if state.clearOnSend { state.commandToSend = "" }
      return .none
      
    case .startStopButton:
      // current state?
      if state.radio == nil {
        // NOT connected, check for a default
        if state.useDefault, let params = hasDefault(state) {
          let packetId = params.0
          state.station = params.1
          // YES, is it Wan?
          if state.model.packets[id: packetId]?.source == .smartlink {
            // YES, reply will generate a wanStatus action
            state.pendingWanId = packetId
            state.wanListener!.sendWanConnectMessage(for: state.model.packets[id: packetId]!.serial, holePunchPort: state.model.packets[id: packetId]!.negotiatedHolePunchPort)
            return .none
            
          } else {
            // NO, check for other connections
            return Effect(value: .checkConnectionStatus(packetId))
          }
          
        } else {
          // no default, or failed to find a match, open the Picker
          state.pickerState = PickerState(pickables: getPickables(state),
                                          isGui: state.isGui,
                                          defaultId: nil,
                                          selectedId: nil,
                                          testResult: false)
          return .none
        }
        
      } else {
        // CONNECTED, disconnect
        state.radio?.disconnect()
        state.radio = nil
        if state.clearOnDisconnect {
          state.messages.removeAll()
          state.filteredMessages.removeAll()
        }
        return .none
      }
      
    case .toggle(let keyPath):
      // handles all buttons with a Bool state
      state[keyPath: keyPath].toggle()
      if keyPath == \.forceWanLogin && state.forceWanLogin {
        // re-initialize if forcing Wan login
        return Effect(value: .finishInitialization)
      }
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Picker Actions (PickerView -> ApiView)
      
    case .pickerAction(.cancelButton):
      // CANCEl, close the Picker sheet
      state.pickerState = nil
      return .none
      
    case .pickerAction(.connectButton( _, let packetId, let station)):
      // CONNECT, close the Picker sheet
      state.pickerState = nil
      state.station = station
      // is it Smartlink?
      if state.model.packets[id: packetId]?.source == .smartlink {
        // YES, send the Wan Connect message
        state.pendingWanId = packetId
        state.wanListener!.sendWanConnectMessage(for: state.model.packets[id: packetId]!.serial, holePunchPort: state.model.packets[id: packetId]!.negotiatedHolePunchPort)
        // the reply to this will generate a wanStatus action
        return .none
        
      } else {
        // check for other connections
        return Effect(value: .checkConnectionStatus(packetId))
      }
      
    case .pickerAction(.defaultButton( _, let packetId, let station)):
      // SET / RESET the default, valid Id?
      if let packet = state.model.packets[id: packetId] {
        // YES, gui?
        if state.isGui {
          // YES, gui
          let newValue =  DefaultValue(packet.serial, packet.source, nil)
          if state.guiDefault == newValue {
            state.guiDefault = nil
          } else {
            state.guiDefault = newValue
          }
        } else {
          // NO, nonGui
          let newValue =  DefaultValue(packet.serial, packet.source, station)
          if state.nonGuiDefault == newValue {
            state.nonGuiDefault = nil
          } else {
            state.nonGuiDefault = newValue
          }
        }
      }
      return .none
      
    case .pickerAction(.testButton(let id, let packetId)):
      // TEST BUTTON, send a Test request
      state.wanListener!.sendSmartlinkTest(state.model.packets[id: packetId]!.serial)
      // reply will generate a testResult action
      return subscribeToTest()
      
    case .pickerAction(_):
      // IGNORE ALL OTHER picker actions
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - ClientView Actions (ClientView -> ApiView)
      
    case .clientAction(.cancelButton):
      // CANCEL
      state.clientState = nil
      // additional processing upstream
      return .none
      
    case .clientAction(.connect(let packetId, let handle)):
      // CONNECT
      state.clientState = nil
      return Effect(value: .openSelection(packetId, handle))
            
      // ----------------------------------------------------------------------------
      // MARK: - LoginView Actions (LoginView -> ApiView)
      
    case .loginAction(.cancelButton):
      // CANCEL
      state.loginState = nil
      return .none
      
    case .loginAction(.loginButton(let user, let pwd)):
      // LOGIN
      state.loginState = nil
      // save the credentials
      let secureStore = SecureStore(service: "ApiViewer")
      _ = secureStore.set(account: "user", data: user)
      _ = secureStore.set(account: "pwd", data: pwd)
      state.smartlinkEmail = user
      // try a Smartlink login
      if state.wanListener!.start(using: LoginResult(user, pwd: pwd)) {
        state.forceWanLogin = false
      } else {
        state.alert = AlertState(title: TextState("Smartlink login failed"))
      }
      return .none
      
    case .loginAction(_):
      // IGNORE ALL OTHER login actions
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Alert Action: (Alert is closed)
      
    case .alertDismissed:
      state.alert = nil
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Effects Actions (long-running effects)
      
    case .cancelEffects:
      return .cancel(ids:
                      [
                        LogAlertSubscriptionId(),
                        SentSubscriptionId(),
                        ReceivedSubscriptionId(),
                        MeterSubscriptionId()
                      ]
      )
      
    case .logAlertReceived(let logEntry):
      // a Warning or Error has been logged.
      // exit any sheet states
      state.pickerState = nil
      state.loginState = nil
      // alert the user
      state.alert = .init(title: TextState(
                                    """
                                    \(logEntry.level == .warning ? "A Warning" : "An Error") was logged:
                                    
                                    \(logEntry.msg)
                                    """
      )
      )
      return .none
      
    case .tcpMessage(let message):
      // a TCP messages (either sent or received) has been captured
      // ignore sent "ping" messages unless showPings is true
      if message.direction == .sent && message.text.contains("ping") && state.showPings == false { return .none }
      // add the message to the collection
      state.messages.append(message)
      // re-filter
      state.filteredMessages = filterMessages(state, state.messagesFilterBy, state.messagesFilterByText)
      return .none
      
    case .meterReceived(let meter):
      // an updated neter value has been received
      state.forceUpdate.toggle()
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Actions sent by other actions
      
    case .checkConnectionStatus(let packetId):
      // making a Gui connection and other Gui connections exist?
      if state.isGui && state.model.packets[id: packetId]!.guiClients.count > 0 {
        // YES, may need a disconnect, let the user choose
        var stations = [String]()
        var handles = [Handle]()
        if let packet = state.model.packets[id: packetId] {
          for client in packet.guiClients {
            stations.append(client.station)
            handles.append(client.handle)
          }
        }
        state.clientState = ClientState(selectedId: packetId, stations: stations, handles: handles)
        return .none
        
      } else {
        // NO, proceed to opening
        return Effect(value: .openSelection(packetId, nil))
      }
      
    case .clientChangeReceived(let update):
      // a guiClient change has been observed
      // are we connected as a nonGui?
      if state.isGui == false {
        // YES, is there a clientId for our connected Station?
        if update.client.clientId != nil && update.client.station == state.station {
          // YES, bind to it
          state.radio?.bindToGuiClient(update.client.clientId)
        }
      }
      return .none
      
    case .openSelection(let packetId, let disconnectHandle):      
      // open the selected packet, optionally disconnect another station
      if let packet = state.model.packets[id: packetId] {
        // instantiate a Radio object
        state.radio = Radio(packet,
                            connectionType: state.isGui ? .gui : .nonGui,
                            command: state.tcp,
                            stream: Udp(),
                            stationName: "Mac",
                            programName: "Api6000Tester",
                            disconnectHandle: disconnectHandle,
                            testerModeEnabled: true)
        // try to connect
        if state.radio!.connect(packet) {
          // connected
          if state.clearOnConnect {
            state.messages.removeAll()
            state.filteredMessages.removeAll()
          }
        } else {
          // failed
          state.radio = nil
          state.alert = AlertState(title: TextState("Failed to connect to Radio \(packet.nickname)"))
        }
      }
      return .none
      
    case .packetChangeReceived(_):
      // a packet change has been observed
      if state.pickerState != nil {
        state.pickerState!.pickables = getPickables(state)
      }
      return .none
      
    case .testResult(let result):
      // a test result has been received
      state.pickerState?.testResult = result.success
      return .none
      
    case .wanStatus(let status):
      // a WanStatus message has been received, was it successful?
      if state.pendingWanId != nil && status.type == .connect && status.wanHandle != nil {
        // YES, set the wan handle
        state.model.packets[id: state.pendingWanId!]!.wanHandle = status.wanHandle!
        // check for other connections
        return Effect(value: .checkConnectionStatus(state.pendingWanId!))
      }
      return .none
    }
  }
)
//  .debug("APIVIEWER ")


// ----------------------------------------------------------------------------
// MARK: - Helper methods

/// FIlter the Messages array
/// - Parameters:
///   - state:         the current ApiState
///   - filterBy:      the selected filter choice
///   - filterText:    the current filter text
/// - Returns:         a filtered array
func filterMessages(_ state: ApiState, _ filterBy: MessagesFilter, _ filterText: String) -> IdentifiedArrayOf<TcpMessage> {
  var filteredMessages = IdentifiedArrayOf<TcpMessage>()
  
  // re-filter messages
  switch (filterBy, filterText) {
    
  case (.all, _):        filteredMessages = state.messages
  case (.prefix, ""):    filteredMessages = state.messages
  case (.prefix, _):     filteredMessages = state.messages.filter { $0.text.localizedCaseInsensitiveContains("|" + filterText) }
  case (.includes, _):   filteredMessages = state.messages.filter { $0.text.localizedCaseInsensitiveContains(filterText) }
  case (.excludes, ""):  filteredMessages = state.messages
  case (.excludes, _):   filteredMessages = state.messages.filter { !$0.text.localizedCaseInsensitiveContains(filterText) }
  case (.command, _):    filteredMessages = state.messages.filter { $0.text.prefix(1) == "C" }
  case (.S0, _):         filteredMessages = state.messages.filter { $0.text.prefix(3) == "S0|" }
  case (.status, _):     filteredMessages = state.messages.filter { $0.text.prefix(1) == "S" && $0.text.prefix(3) != "S0|"}
  case (.reply, _):      filteredMessages = state.messages.filter { $0.text.prefix(1) == "R" }
  }
  return filteredMessages
}

/// Read the user defaults entry for a default connection and transform it into a DefaultConnection struct
/// - Parameters:
///    - type:         gui / nonGui
/// - Returns:         a DefaultValue struct or nil
public func getDefaultValue(_ type: ConnectionType) -> DefaultValue? {
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
func setDefaultValue(_ type: ConnectionType, _ value: DefaultValue?) {
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
/// - Returns:          a tuple of the PacketId and an optional Station
func hasDefault(_ state: ApiState) -> (UUID, String?)? {
  if state.isGui {
    if let defaultValue = state.guiDefault {
      for packet in state.model.packets where defaultValue.source == packet.source.rawValue && defaultValue.serial == packet.serial {
        // found one
        return (packet.id, nil)
      }
    }
  } else {
    if let defaultValue = state.nonGuiDefault {
      for packet in state.model.packets where defaultValue.source == packet.source.rawValue && defaultValue.serial == packet.serial  && packet.guiClientStations.contains(defaultValue.station!){
        // found one
        return (packet.id, defaultValue.station)
      }
    }
  }
  // NO default or failed to find a match
  return nil
}

/// Produce an IdentifiedArray of items that can be picked
/// - Parameter state:  ApiCore state
/// - Returns:          an array of items that can be picked
func getPickables(_ state: ApiState) -> IdentifiedArrayOf<Pickable> {
  var pickables = IdentifiedArrayOf<Pickable>()
  if state.isGui {
    // GUI
    for packet in state.model.packets {
      pickables.append( Pickable(id: packet.id,
                                 packetId: packet.id,
                                 isLocal: packet.source == .local,
                                 name: packet.nickname,
                                 status: packet.status,
                                 station: packet.guiClientStations,
                                 isDefault: packet.serial == state.guiDefault?.serial && packet.source.rawValue == state.guiDefault?.source)
      )
    }

  } else {
    // NON-GUI
    for packet in state.model.packets {
      for guiClient in packet.guiClients {
        pickables.append( Pickable(id: UUID(),
                                   packetId: packet.id,
                                   isLocal: packet.source == .local,
                                   name: packet.nickname,
                                   status: packet.status,
                                   station: guiClient.station,
                                   isDefault: packet.serial == state.nonGuiDefault?.serial && packet.source.rawValue == state.nonGuiDefault?.source && packet.guiClientStations == state.nonGuiDefault?.station)
        )
      }
    }
  }
  return pickables
}
