//
//  ApiCore.swift
//  Api6000Components/ApiViewer
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
    timeInterval: TimeInterval? = nil,
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
  public var timeInterval: TimeInterval?
  public var color: Color
}

public struct DefaultValue: Equatable, Codable {
  public var serial: String
  public var source: String
  public var station: String?
  
  public init
  (
    _ selection: PickableSelection
  )
  {
    self.serial = selection.serial
    self.source = selection.source
    self.station = selection.station
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
  
  public var clearOnSend: Bool { didSet { UserDefaults.standard.set(clearOnSend, forKey: "clearOnSend") } }
  public var clearOnStart: Bool { didSet { UserDefaults.standard.set(clearOnStart, forKey: "clearOnStart") } }
  public var clearOnStop: Bool { didSet { UserDefaults.standard.set(clearOnStop, forKey: "clearOnStop") } }
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
  //  public var clientState: ClientState?
  public var commandToSend = ""
  public var initialized = false
  public var lanListener: LanListener?
  public var wanListener: WanListener?
  public var filteredMessages = IdentifiedArrayOf<TcpMessage>()
  public var forceWanLogin = false
  public var forceUpdate = false
  //  public var loginState: LoginState? = nil
  public var messages = IdentifiedArrayOf<TcpMessage>()
  //  public var model = Model.shared
  public var pendingWanId: UUID?
  public var pickerState: PickerState? = nil
  public var radio: Radio?
  public var reverseLog = false
  public var station: String? = nil
  public var tcp = Tcp.shared
  
  public var startTime: Date?
  
  public init(
    clearOnSend: Bool  = UserDefaults.standard.bool(forKey: "clearOnSend"),
    clearOnStart: Bool = UserDefaults.standard.bool(forKey: "clearOnStart"),
    clearOnStop: Bool  = UserDefaults.standard.bool(forKey: "clearOnStop"),
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
    self.clearOnStart = clearOnStart
    self.clearOnStop = clearOnStop
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
  case sendButton(String)
  case startStopButton
  case toggle(WritableKeyPath<ApiState, Bool>)
  
  // subview/sheet/alert related
  //  case alertDismissed
  //  case clientAction(ClientAction)
  //  case loginAction(LoginAction)
  case picker(PickerAction)
  
  // Effects related
  case returnPickables(IdentifiedArrayOf<Pickable>)
  //  case cancelEffects
  case checkConnectionStatus(PickableSelection)
  //  case clientChangeReceived(ClientUpdate)
  case finishInitialization
  //  case logAlertReceived(LogEntry)
  //  case meterReceived(Meter)
  case openSelection(PickableSelection, Handle?)
  case radioConnected(Bool)
  case packetEvent(PacketEvent)
  //  case testResult(SmartlinkTestResult)
  case tcpMessage(TcpMessage)
  //  case wanStatus(WanStatus)
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
  //  clientReducer
  //    .optional()
  //    .pullback(
  //      state: \ApiState.clientState,
  //      action: /ApiAction.clientAction,
  //      environment: { _ in ClientEnvironment() }
  //    ),
  //  loginReducer
  //    .optional()
  //    .pullback(
  //      state: \ApiState.loginState,
  //      action: /ApiAction.loginAction,
  //      environment: { _ in LoginEnvironment() }
  //    ),
  pickerReducer
    .optional()
    .pullback(
      state: \ApiState.pickerState,
      action: /ApiAction.picker,
      environment: { _ in PickerEnvironment() }
    ),
  Reducer
  { state, action, environment in
    
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
          .run { send in
            for await event in await Model.shared.packetEvents {
              // a packet change has been observed
              await send(.packetEvent(event))
            }
          },
          .run { send in
            // process the AsyncStream of Tcp messages sent from the Radio
            for await message in Tcp.shared.tcpInbound {
              
              // pass them to the API
              await Model.shared.radio?.tcpInbound(message)

              // ignore reply unless it is non-zero or contains additional data
              if ignoreReply(message) { continue }

              // convert to TcpMessage format, add to the collection and refilter
              await send(.tcpMessage(TcpMessage(text: message, direction: .received)))
            }
          },
          .run { send in
            // process the AsyncStream of Tcp messages sent to the Radio
            for await message in Tcp.shared.tcpOutbound {
              
              print("-----> Sent", message)
              
              //      // ignore sent "ping" messages unless showPings is true
              //      if message.contains("ping") && showPings == false { continue }
              //
              //      // convert to TcpMessage format, add to the collection and refilter
              //      let tcpMessage = TcpMessage(text: message, direction: .sent, timeInterval: Date().timeIntervalSince( _startTime!))
              //      messages.append( tcpMessage )
              //      filterMessages()
            }
          },
          .run { send in
            await send(.finishInitialization)
          }
        )
        
//        subscribeToPackets()
//        subscribeToSent()
//        subscribeToReceived()
//        return Effect(value: .finishInitialization)
//        return .run { send in
//          for await notification in await Model.shared.packetUpdate {
//            // a packet change has been observed
//
//            print("----->", notification)
//
//           }
//        }

//          subscribeToSent(state.tcp),
//          subscribeToReceived(state.tcp),
//          await send(.finishInitialization)
//        }
        //          .merge(
        //          subscribeToPackets(),
        //          subscribeToWan(),
        //          subscribeToSent(state.tcp),
        //          subscribeToReceived(state.tcp),
        //          subscribeToLogAlerts(),
        //          Effect(value: .finishInitialization))
      }
      return .none
      
    case .toggle(let keyPath):
      // handles all buttons with a Bool state
      state[keyPath: keyPath].toggle()
      if keyPath == \.forceWanLogin && state.forceWanLogin {
        // re-initialize if forcing Wan login
        return Effect(value: .connectionModePicker(state.connectionMode))
      }
      return .none
      
    case .connectionModePicker(let mode):
      state.connectionMode = mode
      // needed when coming from other than .onAppear
      state.lanListener?.stop()
      state.lanListener = nil
      state.wanListener?.stop()
      state.wanListener = nil
      return .run { send in
        await Model.shared.removePackets(condition: { _ in true } )
        await send(.finishInitialization)
      }
      
    case .finishInitialization:
      // start / stop listeners as appropriate for the Mode
      switch state.connectionMode {
      case .local:
        state.lanListener = LanListener()
        state.lanListener!.start()
      case .smartlink:
        state.wanListener = WanListener()
        if state.forceWanLogin || state.wanListener!.start(state.smartlinkEmail) == false {
          //          state.loginState = LoginState(heading: "Smartlink Login required")
        }
      case .both:
        state.lanListener = LanListener()
        state.lanListener!.start()
        state.wanListener = WanListener()
        if state.forceWanLogin || state.wanListener!.start(state.smartlinkEmail) == false {
          //          state.loginState = LoginState(heading: "Smartlink Login required")
        }
      case .none:
        break
      }
      return .none
      
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
      
    case .fontSizeStepper(let size):
      state.fontSize = size
      return .none
      
    case .commandTextField(let text):
      state.commandToSend = text
      return .none
      
    case .sendButton(let command):
      if state.clearOnSend { state.commandToSend = "" }
      return .run { send in
        _ = await Tcp.shared.send(command)
      }
      
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
      
      return .none
      
    case .startStopButton:
      // current state?
//      if isConnected == false {
//        // NOT connected
//        if clearOnStart {
//          messages.removeAll()
//          filteredMessages.removeAll()
//        }
//
//        // check for a default
//        let (packet, station) = getDefault(isGui)
//        if useDefault && packet != nil {
//          _station = station
//          // YES, is it Wan?
//          if packet!.source == .smartlink {
//            // YES, reply will generate a wanStatus action
//            pendingWan = (packet!, station)
//            _wanListener?.sendWanConnectMessage(for: packet!.serial, holePunchPort: packet!.negotiatedHolePunchPort)
//
//          } else {
//            // NO, check for other connections
//            checkConnectionStatus(packet!)
//          }
//
//        } else {
          // not using default OR no default OR failed to find a match, open the Picker
      if state.radio == nil {
        return .run { [state] send in
          var pickables = IdentifiedArrayOf<Pickable>()
          if state.isGui {
            pickables = await Model.shared.getPickables(true)
          } else {
            pickables = await Model.shared.getPickables(false)
          }
          await send(.returnPickables(pickables))
        }
      } else {
        return .none
      }
      
    case .returnPickables(let pickables):
      state.pickerState = PickerState(pickables: pickables)
      return .none

    case .checkConnectionStatus(let selection):
      // making a Gui connection and other Gui connections exist?
//      if state.isGui && state.model.packets[id: packetId]!.guiClients.count > 0 {
//        // YES, may need a disconnect, let the user choose
//        var stations = [String]()
//        var handles = [Handle]()
//        if let packet = state.model.packets[id: packetId] {
//          for client in packet.guiClients {
//            stations.append(client.station)
//            handles.append(client.handle)
//          }
//        }
//        state.clientState = ClientState(selectedId: packetId, stations: stations, handles: handles)
//        return .none
//
//      } else {
//        // NO, proceed to opening
        return Effect(value: .openSelection(selection, nil))
//      }

      
      
//      private func openSelection(_ packet: Packet, _ disconnectHandle: Handle?) {
//        isConnected = true
//        _startTime = Date()
//
//        // instantiate a Radio object and attempt to connect
//        if Model.shared.createRadio(packet: packet, isGui: isGui, disconnectHandle: disconnectHandle, station: "Mac", program: "Api6000Tester", testerMode: true) {
//          // connected
//          filterMessages()
//        } else {
//          // failed
//          isConnected = false
//          alertModel = AlertModel(title: "Connection", message: "Failed to connect to \(packet.nickname)", action: {self.alertDismissed()} )
//        }
//      }

      
      
      
      

    case .openSelection(let selection, let disconnectHandle):
      
      state.startTime = Date()

      print("Selection (Open) = \(selection)")
      
      
      return .run { [state] send in
        var connected: Bool = false
        // open a Radio using the selected packet, optionally disconnect another station
        let radio = await Radio(selection.packetId,
                                connectionType: state.isGui ? .gui : .nonGui,
                                command: Tcp.shared,
                                stream: Udp.shared,
                                stationName: "Mac",
                                programName: "Api6000Tester",
                                disconnectHandle: disconnectHandle,
                                testerModeEnabled: true)
        if let radio = radio {
          connected = await radio.connect(radio.packet!)
        }
        await send(.radioConnected(connected))
      }
    
    case .radioConnected(let connected):
      if connected {
        // connected
        if state.clearOnStart {
          state.messages.removeAll()
          state.filteredMessages.removeAll()
        }
      } else {
        // failed
        state.alert = AlertState(title: TextState("Failed to connect to Radio"))
      }
      return .none

        // try to connect

    case .packetEvent(_):
      return .run { [state] send in
        var pickables = IdentifiedArrayOf<Pickable>()
        if state.isGui {
          pickables = await Model.shared.getPickables(true)
        } else {
          pickables = await Model.shared.getPickables(false)
        }
        await send(.returnPickables(pickables))
      }

    case .tcpMessage(var message):
      // a TCP messages (either sent or received) has been captured
      message.timeInterval = Date().timeIntervalSince( state.startTime!)
      // ignore sent "ping" messages unless showPings is true
      if message.direction == .sent && message.text.contains("ping") && state.showPings == false { return .none }
      // add the message to the collection
      state.messages.append(message)
      // re-filter
      state.filteredMessages = filterMessages(state, state.messagesFilterBy, state.messagesFilterByText)
      return .none

      // ----------------------------------------------------------------------------
      // MARK: - Picker Actions (PickerView -> ApiView)
      
    case .picker(.cancelButton):
      // CANCEl, close the Picker sheet
      state.pickerState = nil
      return .none
      
    case .picker(.connectButton(let selection)):
      // CONNECT, close the Picker sheet
      
      print("Selection (connect) = \(selection)")

      
      state.pickerState = nil
      state.station = selection.station
      // is it Smartlink?
      if selection.source == PacketSource.smartlink.rawValue {
        // YES, send the Wan Connect message
        state.pendingWanId = selection.packetId
        
        // FIXME: where to get the holePunchPort ???
        
        state.wanListener!.sendWanConnectMessage(for: selection.serial, holePunchPort: 0)
        // the reply to this will generate a wanStatus action
        return .none
        
      } else {
        // check for other connections
        return Effect(value: .checkConnectionStatus(selection))
      }
      
    case .picker(.defaultButton(let selection)):
      // SET / RESET the default
      // gui?
      if state.isGui {
        // YES, gui
        let newValue =  DefaultValue(selection)
        if state.guiDefault == newValue {
          state.guiDefault = nil
          state.pickerState?.defaultId = nil
        } else {
          state.guiDefault = newValue
          state.pickerState?.defaultId = selection.packetId
        }
      } else {
        // NO, nonGui
        let newValue =  DefaultValue(selection)
        if state.nonGuiDefault == newValue {
          state.nonGuiDefault = nil
          state.pickerState?.defaultId = nil
        } else {
          state.nonGuiDefault = newValue
          state.pickerState?.defaultId = selection.packetId
        }
      }
      return .none
      
    case .picker(.testButton(let selection)):
      //      // TEST BUTTON, send a Test request
      //      state.wanListener!.sendSmartlinkTest(state.model.packets[id: packetId]!.serial)
      //      // reply will generate a testResult action
      //      return subscribeToTest()
      return .none
      
    case .picker(.selectionAction(let selection)):
      state.pickerState?.selection = selection
      
      print("Selection = \(selection)")
      
      
      return .none
      
    case .picker(_):
      // IGNORE ALL OTHER picker actions
      return .none
      
    }
  }
)

// ----------------------------------------------------------------------------
//      // MARK: - Actions: ApiView UI
//

//    case .connectionModePicker(let mode):
//      state.connectionMode = mode
//      return Effect(value: .finishInitialization)
//
//    case .toggle(let keyPath):
//      // handles all buttons with a Bool state
//      state[keyPath: keyPath].toggle()
//      if keyPath == \.forceWanLogin && state.forceWanLogin {
//        // re-initialize if forcing Wan login
//        return Effect(value: .finishInitialization)
//      }
//      return .none
//      // ----------------------------------------------------------------------------
//      // MARK: - ClientView Actions (ClientView -> ApiView)
//
//    case .clientAction(.cancelButton):
//      // CANCEL
//      state.clientState = nil
//      // additional processing upstream
//      return .none
//
//    case .clientAction(.connect(let packetId, let handle)):
//      // CONNECT
//      state.clientState = nil
//      return Effect(value: .openSelection(packetId, handle))
//
//      // ----------------------------------------------------------------------------
//      // MARK: - LoginView Actions (LoginView -> ApiView)
//
//    case .loginAction(.cancelButton):
//      // CANCEL
//      state.loginState = nil
//      return .none
//
//    case .loginAction(.loginButton(let user, let pwd)):
//      // LOGIN
//      state.loginState = nil
//      // save the credentials
//      let secureStore = SecureStore(service: "ApiViewer")
//      _ = secureStore.set(account: "user", data: user)
//      _ = secureStore.set(account: "pwd", data: pwd)
//      state.smartlinkEmail = user
//      // try a Smartlink login
//      if state.wanListener!.start(using: LoginResult(user, pwd: pwd)) {
//        state.forceWanLogin = false
//      } else {
//        state.alert = AlertState(title: TextState("Smartlink login failed"))
//      }
//      return .none
//
//    case .loginAction(_):
//      // IGNORE ALL OTHER login actions
//      return .none
//
//      // ----------------------------------------------------------------------------
//      // MARK: - Alert Action: (Alert is closed)
//
//    case .alertDismissed:
//      state.alert = nil
//      return .none
//
//      // ----------------------------------------------------------------------------
//      // MARK: - Effects Actions (long-running effects)
//
//    case .cancelEffects:
//      return .cancel(ids:
//                      [
//                        LogAlertSubscriptionId(),
//                        SentSubscriptionId(),
//                        ReceivedSubscriptionId(),
//                        MeterSubscriptionId()
//                      ]
//      )
//
//    case .logAlertReceived(let logEntry):
//      // a Warning or Error has been logged.
//      // exit any sheet states
//      state.pickerState = nil
//      state.loginState = nil
//      // alert the user
//      state.alert = .init(title: TextState("\(logEntry.level == .warning ? "A Warning" : "An Error") was logged:"),
//                          message: TextState(logEntry.msg))
//
//      return .none
//
//    case .meterReceived(let meter):
//      // an updated neter value has been received
//      state.forceUpdate.toggle()
//      return .none
//
//      // ----------------------------------------------------------------------------
//      // MARK: - Actions sent by other actions
//
//    case .clientChangeReceived(let update):
//      // a guiClient change has been observed
//      // are we connected as a nonGui?
//      if state.isGui == false {
//        // YES, is there a clientId for our connected Station?
//        if update.client.clientId != nil && update.client.station == state.station {
//          // YES, bind to it
//          state.radio?.bindToGuiClient(update.client.clientId)
//        }
//      }
//      return .none
//
//
//    case .testResult(let result):
//      // a test result has been received
//      state.pickerState?.testResult = result.success
//      return .none
//
//    case .wanStatus(let status):
//      // a WanStatus message has been received, was it successful?
//      if state.pendingWanId != nil && status.type == .connect && status.wanHandle != nil {
//        // YES, set the wan handle
//        state.model.packets[id: state.pendingWanId!]!.wanHandle = status.wanHandle!
//        // check for other connections
//        return Effect(value: .checkConnectionStatus(state.pendingWanId!))
//      }
//      return .none
//    }
//  }
//)
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

///// Determine if there is default radio connection
///// - Parameter state:  ApiCore state
///// - Returns:          a tuple of the PacketId and an optional Station
//func hasDefault(_ state: ApiState) -> (UUID, String?)? {
//  if state.isGui {
//    if let defaultValue = state.guiDefault {
//      for packet in state.model.packets where defaultValue.source == packet.source.rawValue && defaultValue.serial == packet.serial {
//        // found one
//        return (packet.id, nil)
//      }
//    }
//  } else {
//    if let defaultValue = state.nonGuiDefault {
//      for packet in state.model.packets where defaultValue.source == packet.source.rawValue && defaultValue.serial == packet.serial  && packet.guiClientStations.contains(defaultValue.station!){
//        // found one
//        return (packet.id, defaultValue.station)
//      }
//    }
//  }
//  // NO default or failed to find a match
//  return nil
//}
//
//
//
//// ----------------------------------------------------------------------------
//// MARK: - Private (subscriptions)

private func subscribeToPackets() {
  
  Task {
    print("----------> subscribeToPackets: STARTED")
    for await notification in await Model.shared.packetEvents {
      // a packet change has been observed
      
      print("-----> Packet", notification)
            
     }
    print("-----> subscribeToPackets: STOPPED")
  }
}

//private func subscribeToClients() {
//  Task {
////      print("----------> subscribeToClients: STARTED")
//    for await update in await Model.shared.clientUpdate {
//      // a guiClient change has been observed
//      switch update.action {
//      case .added, .deleted:  break
//
//      case .completed:
//        if isConnected && isGui == false {
//          // YES, is there a clientId for our connected Station?
//          if update.client.clientId != nil && update.client.station == _station {
//            // YES, bind to it
//            await Model.shared.radio?.bindToGuiClient(update.client.clientId)
//            Model.shared.activeStation = _station
//          }
//        }
//      }
//    }
////      print("-----> subscribeToClients: STOPPED")
//  }
//}

private func subscribeToTcpStatus() {
  Task {
//      print("----------> subscribeToTcpStatus: STARTED")
    for await status in Tcp.shared.tcpStatus {
      // pass them to the API
      await Model.shared.radio?.tcpStatus(status)
    }
//      print("-----> subscribeToTcpStatus: STOPPED")
  }
}

public func subscribeToUdpStatus() {
  Task {
//      print("----------> subscribeToUdpStatus: STARTED")
    for await status in Udp.shared.udpStatus {
      await Model.shared.radio?.udpStatus(status)
    }
//      print("-----> subscribeToUdpStatus: STOPPED")
  }
}

private func subscribeToSent() {
  Task {
    print("----------> subscribeToSent: STARTED")
    // process the AsyncStream of Tcp messages sent to the Radio
    for await message in Tcp.shared.tcpOutbound {
      
      print("-----> Sent", message)
      
      //      // ignore sent "ping" messages unless showPings is true
      //      if message.contains("ping") && showPings == false { continue }
      //
      //      // convert to TcpMessage format, add to the collection and refilter
      //      let tcpMessage = TcpMessage(text: message, direction: .sent, timeInterval: Date().timeIntervalSince( _startTime!))
      //      messages.append( tcpMessage )
      //      filterMessages()
    }
    print("-----> subscribeToSent: STOPPED")
  }
}

//private func unSubscribeToSent() {
//  _tcpSentTask?.cancel()
//}

private func subscribeToReceived() {
  Task {
      print("----------> subscribeToReceived: STARTED")
    // process the AsyncStream of Tcp messages sent from the Radio
    for await message in Tcp.shared.tcpInbound {
      
      print("-----> Received", message)

      // pass them to the API
      await Model.shared.radio?.tcpInbound(message)

      // ignore reply unless it is non-zero or contains additional data
      if ignoreReply(message) { continue }

      // convert to TcpMessage format, add to the collection and refilter
//      let tcpMessage = TcpMessage(text: message, direction: .received, timeInterval: Date().timeIntervalSince( _startTime!))
//      messages.append( tcpMessage )
//      filterMessages()
    }
      print("-----> subscribeToReceived: STOPPED")
  }
}
//private func unSubscribeToReceived() {
//  _tcpReceivedTask?.cancel()
//}

//private func subscribeToWan() {
//  // subscribe to the publisher of Wan messages
// wanSubscription = NotificationCenter.default.publisher(for: wanNotification, object: nil)
//    .receive(on: DispatchQueue.main)
//    .sink { [self] note in
//      wanStatusReceived( note.object as! WanNotification )
//    }
//}
//
//private func subscribeToTest() {
//  // subscribe to the publisher of Smartlink test results
//  testSubscription = NotificationCenter.default.publisher(for: testNotification, object: nil)
//    .receive(on: DispatchQueue.main)
//    .sink { [self] note in
//      testResultReceived( note.object as! TestNotification)
//    }
//}
//
//private func subscribeToLogAlerts() {
//  #if DEBUG
//  Task {
////      print("----------> subscribeToLogAlerts: STARTED")
//    for await entry in logAlerts {
//      // a Warning or Error has been logged.
//      // exit any sheet states
//      pickerModel = nil
//      loginModel = nil
//      // alert the user
//      alertModel = AlertModel(title: "\(entry.level == .warning ? "A Warning" : "An Error") was logged",
//                              message: entry.msg,
//                              action: {self.alertDismissed()} )
//    }
////      print("-----> subscribeToLogAlerts: STOPPED")
//  }
//  #endif
//}

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
