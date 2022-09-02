//
//  ApiCore.swift
//  Api6000Components/ApiViewer
//
//  Created by Douglas Adams on 11/24/21.
//

import ComposableArchitecture
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
// MARK: - State, Actions & Environment

public struct ApiState: Equatable {  
  // State held in User Defaults
  public var clearOnSend: Bool { didSet { UserDefaults.standard.set(clearOnSend, forKey: "clearOnSend") } }
  public var clearOnStart: Bool { didSet { UserDefaults.standard.set(clearOnStart, forKey: "clearOnStart") } }
  public var clearOnStop: Bool { didSet { UserDefaults.standard.set(clearOnStop, forKey: "clearOnStop") } }
  public var connectionMode: ConnectionMode { didSet { UserDefaults.standard.set(connectionMode.rawValue, forKey: "connectionMode") } }
  public var guiDefault: DefaultValue? { didSet { setDefaultValue(.gui, guiDefault) } }
  public var fontSize: CGFloat { didSet { UserDefaults.standard.set(fontSize, forKey: "fontSize") } }
  public var isGui: Bool { didSet { UserDefaults.standard.set(isGui, forKey: "isGui") } }
  public var messageFilter: MessageFilter { didSet { UserDefaults.standard.set(messageFilter.rawValue, forKey: "messageFilter") } }
  public var messageFilterText: String { didSet { UserDefaults.standard.set(messageFilterText, forKey: "messageFilterText") } }
  public var nonGuiDefault: DefaultValue? { didSet { setDefaultValue(.nonGui, nonGuiDefault) } }
  public var objectFilter: ObjectFilter { didSet { UserDefaults.standard.set(objectFilter.rawValue, forKey: "objectFilter") } }
  public var reverse: Bool { didSet { UserDefaults.standard.set(reverse, forKey: "reverse") } }
  public var showPings: Bool { didSet { UserDefaults.standard.set(showPings, forKey: "showPings") } }
  public var showTimes: Bool { didSet { UserDefaults.standard.set(showTimes, forKey: "showTimes") } }
  public var smartlinkEmail: String { didSet { UserDefaults.standard.set(smartlinkEmail, forKey: "smartlinkEmail") } }
  public var useDefault: Bool { didSet { UserDefaults.standard.set(useDefault, forKey: "useDefault") } }
  
  // other state
  public var alertState: AlertState<ApiAction>?
  public var clearNow = false
  public var clientState: ClientState?
  public var commandToSend = ""
  public var filteredMessages = IdentifiedArrayOf<TcpMessage>()
  public var forceWanLogin = false
  public var forceUpdate = false
  public var gotoTop = false
  public var initialized = false
  public var isConnected = false
  public var loginState: LoginState? = nil
  public var messages = IdentifiedArrayOf<TcpMessage>()
  public var pickerState: PickerState? = nil
  public var startTime: Date?
  public var station: String? = nil
    
  public init(
    clearOnSend: Bool  = UserDefaults.standard.bool(forKey: "clearOnSend"),
    clearOnStart: Bool = UserDefaults.standard.bool(forKey: "clearOnStart"),
    clearOnStop: Bool  = UserDefaults.standard.bool(forKey: "clearOnStop"),
    connectionMode: ConnectionMode = ConnectionMode(rawValue: UserDefaults.standard.string(forKey: "connectionMode") ?? "local") ?? .local,
    fontSize: CGFloat = UserDefaults.standard.double(forKey: "fontSize") == 0 ? 12 : UserDefaults.standard.double(forKey: "fontSize"),
    guiDefault: DefaultValue? = getDefaultValue(.gui),
    isGui: Bool = UserDefaults.standard.bool(forKey: "isGui"),
    messageFilter: MessageFilter = MessageFilter(rawValue: UserDefaults.standard.string(forKey: "messageFilter") ?? "all") ?? .all,
    messageFilterText: String = UserDefaults.standard.string(forKey: "messageFilterText") ?? "",
    nonGuiDefault: DefaultValue? = getDefaultValue(.nonGui),
    objectFilter: ObjectFilter = ObjectFilter(rawValue: UserDefaults.standard.string(forKey: "objectFilter") ?? "core") ?? .core,
    radio: Radio? = nil,
    reverse: Bool = UserDefaults.standard.bool(forKey: "reverse"),
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
    self.fontSize = fontSize
    self.isGui = isGui
    self.messageFilter = messageFilter
    self.messageFilterText = messageFilterText
    self.nonGuiDefault = nonGuiDefault
    self.objectFilter = objectFilter
    self.reverse = reverse
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
  case clearNowButton
  case commandTextField(String)
  case connectionModePicker(ConnectionMode)
  case fontSizeStepper(CGFloat)
  case messagesPicker(MessageFilter)
  case messagesFilterTextField(String)
  case objectsPicker(ObjectFilter)
  case sendButton(String)
  case startStopButton
  case toggle(WritableKeyPath<ApiState, Bool>)
  
  // subview/sheet/alert related
  case alertDismissed
  case client(ClientAction)
  case login(LoginAction)
  case picker(PickerAction)
  
  // Effects related
  case checkConnectionStatus(Pickable)
  case clientEvent(ClientEvent)
  case finishInitialization
  case logAlert(LogEntry)
  case loginStatus(Bool, String)
  case openSelection(Pickable, Handle?)
  case packetEvent(PacketEvent)
  case radioConnected(Bool)
  case returnPickables(IdentifiedArrayOf<Pickable>, Bool)
  case showErrorAlert(RadioError)
  case smartlinkLoginRequired
  case tcpMessage(TcpMessage)
  case testResult(TestNotification)
}

public struct ApiEnvironment {
  public init(
    queue: @escaping () -> AnySchedulerOf<DispatchQueue> = { .main }
  )
  {
    self.queue = queue
  }
  var queue: () -> AnySchedulerOf<DispatchQueue>
}

// ----------------------------------------------------------------------------
// MARK: - Reducer

public let apiReducer = Reducer<ApiState, ApiAction, ApiEnvironment>.combine(
  clientReducer
    .optional()
    .pullback(
      state: \ApiState.clientState,
      action: /ApiAction.client,
      environment: { _ in ClientEnvironment() }
    ),
  loginReducer
    .optional()
    .pullback(
      state: \ApiState.loginState,
      action: /ApiAction.login,
      environment: { _ in LoginEnvironment() }
    ),
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
      // MARK: - Actions: ApiView Initialization
      
    case .onAppear:
      // if the first time, start various effects
      if state.initialized == false {
        state.initialized = true
        // instantiate the Logger,
        _ = XCGWrapper(logLevel: .debug)
        // start subscriptions
        return .merge(
          subscribeToPackets(),
          subscribeToClients(),
          subscribeToMessages(),
          subscribeToLogAlerts(),
          subscribeToSmartlinkTest(),
          .run { send in
            await send(.finishInitialization)
          }
        )
      }
      return .none
      
    case .finishInitialization:
      // start / stop listeners as appropriate for the Mode
      return .run { [state] send in
        if await Model.shared.setConnectionMode(state.connectionMode, state.smartlinkEmail) == true {
          if state.connectionMode == .smartlink || state.connectionMode == .both {
            if state.forceWanLogin {
              await send(.smartlinkLoginRequired)
            }
          }
        } else {
          await send(.smartlinkLoginRequired)
        }
      }
      
    case .smartlinkLoginRequired:
      state.loginState = LoginState(heading: "Smartlink Login Required")
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Actions: ApiView Buttons
      
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
      
    case .messagesFilterTextField(let text):
      state.messageFilterText = text
      // re-filter
      state.filteredMessages = filterMessages(state, state.messageFilter, state.messageFilterText)
      return .none
      
    case .messagesPicker(let filter):
      state.messageFilter = filter
      // re-filter
      state.filteredMessages = filterMessages(state, state.messageFilter, state.messageFilterText)
      return .none
      
    case .objectsPicker(let newFilter):
      let prevObjectFilter = state.objectFilter
      state.objectFilter = newFilter
      return .none
      
    case .sendButton(let command):
      if state.clearOnSend { state.commandToSend = "" }
      return .run { send in
        _ = await Model.shared.radio?.send(command)
      }
      
    case .startStopButton:
      // current state?
      if state.isConnected {
        log("ApiCore: STOP clicked", .debug, #function, #file, #line)
        // CONNECTED, disconnect
        state.isConnected = false
        if state.clearOnStop {
          state.messages.removeAll()
          state.filteredMessages.removeAll()
        }
        return .run { send in
          await Model.shared.disconnect()
        }
        
      } else {
        // NOT connected, connect
        log("ApiCore: START clicked", .debug, #function, #file, #line)
        if state.clearOnStart {
          state.messages.removeAll()
          state.filteredMessages.removeAll()
        }
        // use the Default?
        return .run { [state] send in
          // get the Pickables
          let pickables = await Model.shared.getPickables(state.isGui, state.guiDefault, state.nonGuiDefault)
          // if using default, is there a default?
          if state.useDefault, let selection = pickables.first(where: { $0.isDefault} ) {
            // YES,
            await send(.checkConnectionStatus(selection))
          } else {
            // NO, open the Picker
            await send(.returnPickables(pickables, true))
          }
        }
      }
      
    case .toggle(let keyPath):
      // handles all buttons with a Bool state
      state[keyPath: keyPath].toggle()
      if keyPath == \.forceWanLogin && state.forceWanLogin {
        // re-initialize if forcing Wan login
        return Effect(value: .connectionModePicker(state.connectionMode))
      }
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Actions: invoked by other actions
      
    case .checkConnectionStatus(let selection):
      // making a Gui connection and other Gui connections exist?
      if state.isGui && selection.packet.guiClients.count > 0 {
        // YES, may need a disconnect, let the user choose
        var stations = [String]()
        var handles = [Handle]()
        for client in selection.packet.guiClients {
          stations.append(client.station)
          handles.append(client.handle)
        }
        // show the client chooser
        state.clientState = ClientState(selection: selection, stations: stations, handles: handles)
        return .none
        
      } else {
        // NO, proceed to opening
        return Effect(value: .openSelection(selection, nil))
      }
      
    case .clientEvent(let event):
      switch event.action {
      case .added:      break
      case .deleted:    break
      case .completed:
        if state.isGui == false {
          // YES, is there a clientId for our connected Station?
          if event.client.station == state.station {
            // YES, bind to it
            return .run { _ in
              await Model.shared.radio?.bindToGuiClient(event.client.clientId)
            }
          }
        }
      }
      return .none
      
    case .logAlert(let logEntry):
      // a Warning or Error has been logged.
      // exit any sheet states
      state.clientState = nil
      state.loginState = nil
      state.pickerState = nil
      // alert the user
      state.alertState = .init(title: TextState("\(logEntry.level == .warning ? "A Warning" : "An Error") was logged:"),
                               message: TextState(logEntry.msg))
      return .none
      
    case .openSelection(let selection, let disconnectHandle):
      state.startTime = Date()
      return .run { [state] send in
        do {
          try await Model.shared.connectTo(selection: selection, isGui: state.isGui, disconnectHandle: disconnectHandle, station: "Tester", program: "Api6000Tester")
          await send(.radioConnected(Model.shared.radio != nil))
        } catch {
          await send(.showErrorAlert( error as! RadioError ))
        }
      }
      
    case .packetEvent(_):
      return .run { [state] send in
        let pickables = await Model.shared.getPickables(state.isGui, state.guiDefault, state.nonGuiDefault)
        await send(.returnPickables(pickables, false))
      }
      
    case .radioConnected(let connected):
      if connected {
        state.isConnected = true
        
      } else {
        // failed
        state.isConnected = false
        state.alertState = AlertState(title: TextState("Failed to connect to Radio"))
      }
      return .none
      
    case .returnPickables(let pickables, let shouldOpen):
      // is the Picker open?
      if state.pickerState == nil && shouldOpen {
        // NO, open it
        state.pickerState = PickerState(pickables: pickables, isGui: state.isGui)
      } else {
        // YES, update the Pickables
        state.pickerState?.pickables = pickables
      }
      return .none
      
    case .tcpMessage(var tcpMessage):
      // ignore sent "ping" messages unless showPings is true
      if tcpMessage.direction == .sent && tcpMessage.text.contains("ping") && state.showPings == false { return .none }
      // set the time interval
      tcpMessage.timeInterval = tcpMessage.timeStamp.timeIntervalSince(state.startTime!)
      // add the message to the collection
      state.messages.append(tcpMessage)
      // re-filter
      state.filteredMessages = filterMessages(state, state.messageFilter, state.messageFilterText, partial: true, tcpMessage: tcpMessage)
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Login Actions (LoginView -> ApiView)
      
    case .login(.cancelButton):
      // CANCEL
      state.loginState = nil
      state.forceWanLogin = false
      return .none
      
    case .login(.loginButton(let user, let pwd)):
      // LOGIN
      state.loginState = nil
      // try a Smartlink login
      return .run { send in
        let success = await Model.shared.smartlinkLogin(user, pwd)
        if success {
          let secureStore = SecureStore(service: "Api6000Tester-C")
          _ = secureStore.set(account: "user", data: user)
          _ = secureStore.set(account: "pwd", data: pwd)
        }
        await send(.loginStatus(success, user))
      }
      
    case .loginStatus(let success, let user):
      if success {
        state.smartlinkEmail = user
        state.forceWanLogin = false
      } else {
        state.alertState = AlertState(title: TextState("Smartlink login failed for \(user)"))
      }
      return .none
      
    case .login(_):
      // IGNORE ALL OTHER login actions
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Picker Actions (PickerView -> ApiView)
      
    case .picker(.cancelButton):
      // CANCEl, close the Picker sheet
      state.pickerState = nil
      return .none
      
    case .picker(.connectButton(let selection)):
      // CONNECT, close the Picker sheet
      state.pickerState = nil
      state.station = selection.station
      // check for other connections
      return Effect(value: .checkConnectionStatus(selection))
      
    case .picker(.defaultButton(let selection)):
      // SET / RESET the default
      // gui?
      if state.isGui {
        // YES, gui
        let newValue = DefaultValue(selection)
        if state.guiDefault == newValue {
          state.guiDefault = nil
        } else {
          state.guiDefault = newValue
        }
      } else {
        // NO, nonGui
        let newValue = DefaultValue(selection)
        if state.nonGuiDefault == newValue {
          state.nonGuiDefault = nil
        } else {
          state.nonGuiDefault = newValue
        }
      }
      // redo the Pickables
      return .run { [state] send in
        let pickables = await Model.shared.getPickables(state.isGui, state.guiDefault, state.nonGuiDefault)
        await send(.returnPickables(pickables, false))
      }
      
    case .picker(.testButton(let selection)):
      // TEST BUTTON, send a Test request
      state.pickerState?.testResult = false
      return .run { send in
        await Model.shared.smartlinkTest(for: selection.packet.serial)
      }
      
    case .picker(_):
      // IGNORE ALL OTHER picker actions
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Client Actions (ClientView -> ApiView)
      
    case .client(.cancelButton):
      // CANCEL
      state.clientState = nil
      // additional processing upstream
      return .none
      
    case .client(.connect(let selection, let handle)):
      // CONNECT
      state.clientState = nil
      return Effect(value: .openSelection(selection, handle))
      
      // ----------------------------------------------------------------------------
      // MARK: - Alert Actions
      
    case .showErrorAlert(let error):
      state.alertState = AlertState(title: TextState("An Error occurred"), message: TextState(error.rawValue))
      return .none
      
    case .alertDismissed:
      state.alertState = nil
      if state.forceWanLogin {
        return .run { send in
          await send(.smartlinkLoginRequired)
        }
      } else {
        return .none
      }
      
      // ----------------------------------------------------------------------------
      // MARK: - Smartlink Test Actions
      
    case .testResult(let result):
      // a test result has been received
      state.pickerState?.testResult = result.success
      return .none
    }
  }
)

// ----------------------------------------------------------------------------
// MARK: - Helper methods

/// FIlter the Messages array
/// - Parameters:
///   - state:         the current ApiState
///   - filterBy:      the selected filter choice
///   - filterText:    the current filter text
/// - Returns:         a filtered array
func filterMessages(_ state: ApiState, _ filter: MessageFilter, _ filterText: String, partial: Bool = false, tcpMessage: TcpMessage? = nil) -> IdentifiedArrayOf<TcpMessage> {
  var filteredMessages = IdentifiedArrayOf<TcpMessage>()
  
  if partial, let tcpMessage = tcpMessage {
    filteredMessages = state.filteredMessages
    // filter the latest entry
    switch (filter, filterText) {
      
    case (.all, _):        filteredMessages.append(tcpMessage)
    case (.prefix, ""):    filteredMessages.append(tcpMessage)
    case (.prefix, _):     if tcpMessage.text.localizedCaseInsensitiveContains("|" + filterText) { filteredMessages.append(tcpMessage) }
    case (.includes, _):   if tcpMessage.text.localizedCaseInsensitiveContains(filterText) { filteredMessages.append(tcpMessage) }
    case (.excludes, ""):  filteredMessages.append(tcpMessage)
    case (.excludes, _):   if !tcpMessage.text.localizedCaseInsensitiveContains(filterText) { filteredMessages.append(tcpMessage) }
    case (.command, _):    if tcpMessage.text.prefix(1) == "C" { filteredMessages.append(tcpMessage) }
    case (.S0, _):         if tcpMessage.text.prefix(3) == "S0|" { filteredMessages.append(tcpMessage) }
    case (.status, _):     if tcpMessage.text.prefix(1) == "S0|" && tcpMessage.text.prefix(3) != "S0|" { filteredMessages.append(tcpMessage) }
    case (.reply, _):      if tcpMessage.text.prefix(1) == "R" { filteredMessages.append(tcpMessage) }
    }
    return filteredMessages
    
  } else {
    // re-filter the entire messages array
    switch (filter, filterText) {
      
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
public func setDefaultValue(_ type: ConnectionType, _ value: DefaultValue?) {
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

// ----------------------------------------------------------------------------
// MARK: - Subscriptions

private func subscribeToPackets() -> Effect<ApiAction, Never> {
  Effect.run { send in
    
    
    log("ApiTester: Packet subscription STARTED", .debug, #function, #file, #line)
    
    
    for await event in await Model.shared.packetEvents {
      // a packet has been added / updated or deleted
      await send(.packetEvent(event))
    }
    
    
    log("ApiTester: Packet subscription STOPPED", .debug, #function, #file, #line)
    
    
  }
}

private func subscribeToClients() -> Effect<ApiAction, Never> {
  Effect.run { send in
    
    
    log("ApiTester: GuiClient subscription STARTED", .debug, #function, #file, #line)
    
    
    for await event in await Model.shared.clientEvents {
      // a guiClient has been added / updated or deleted
      await send(.clientEvent(event))
    }
    
    
    log("ApiTester: GuiClient subscription STOPPED", .debug, #function, #file, #line)
    
    
  }
}

private func subscribeToMessages() -> Effect<ApiAction, Never> {
  Effect.run { send in
    
    
    log("ApiTester: TcpMessage subscription STARTED", .debug, #function, #file, #line)
    
    
    for await tcpMessage in await Model.shared.testerInboundStream {
      // a TCP message was sent or received
      // ignore reply unless it is non-zero or contains additional data
      if tcpMessage.direction == .received && ignoreReply(tcpMessage.text) { continue }
      await send(.tcpMessage(tcpMessage))
    }
    
    
    log("ApiTester: TcpMessage subscription STOPPED", .debug, #function, #file, #line)
    
    
  }
}

private func subscribeToSmartlinkTest() -> Effect<ApiAction, Never> {
  Effect.run { send in
    
    
    log("ApiTester: Test subscription STARTED", .debug, #function, #file, #line)
    
    
    for await result in await Model.shared.testResultStream {
      // the result of a Smartlink Test has been received
      await send(.testResult( result))
    }
    
    
    log("ApiTester: Test subscription STOPPED", .debug, #function, #file, #line)
    
    
  }
}

private func subscribeToLogAlerts() -> Effect<ApiAction, Never>  {
  Effect.run { send in
#if DEBUG
    
    
    log("ApiTester: LogAlert subscription STARTED", .debug, #function, #file, #line)
    
    
    for await entry in logAlerts {
      // a Warning or Error has been logged.
      await send(.logAlert(entry))
    }
    
    
    log("ApiTester: LogAlert subscription STOPPED", .debug, #function, #file, #line)
    
    
#else
    return .none
#endif
  }
}

// ----------------------------------------------------------------------------
// MARK: - Structs and Enums

public enum ViewType: Equatable {
  case api
  case log
  case remote
}

public enum ObjectFilter: String, CaseIterable {
  case core
  case coreNoMeters = "core w/o meters"
  case amplifiers
  case cwx
  case bandSettings = "band settings"
  case equalizers
  case interlock
  case memories
  case profiles
  case meters
  case streams
  case transmit
  case tnfs
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


