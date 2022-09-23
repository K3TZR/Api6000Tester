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
import OpusPlayer
import PickerView
import Shared
import SecureStorage
import XCGWrapper

import RingBuffer

// ----------------------------------------------------------------------------
// MARK: - State, Actions & Environment

public struct ApiState: Equatable {  
  // State held in User Defaults
  var clearOnSend: Bool { didSet { UserDefaults.standard.set(clearOnSend, forKey: "clearOnSend") } }
  var clearOnStart: Bool { didSet { UserDefaults.standard.set(clearOnStart, forKey: "clearOnStart") } }
  var clearOnStop: Bool { didSet { UserDefaults.standard.set(clearOnStop, forKey: "clearOnStop") } }
  var connectionMode: ConnectionMode { didSet { UserDefaults.standard.set(connectionMode.rawValue, forKey: "connectionMode") } }
  var enableAudio: Bool { didSet { UserDefaults.standard.set(enableAudio, forKey: "enableAudio") } }
  var guiDefault: DefaultValue? { didSet { setDefaultValue("guiDefault", guiDefault) } }
  var fontSize: CGFloat { didSet { UserDefaults.standard.set(fontSize, forKey: "fontSize") } }
  var isGui: Bool { didSet { UserDefaults.standard.set(isGui, forKey: "isGui") } }
  var messageFilter: MessageFilter { didSet { UserDefaults.standard.set(messageFilter.rawValue, forKey: "messageFilter") } }
  var messageFilterText: String { didSet { UserDefaults.standard.set(messageFilterText, forKey: "messageFilterText") } }
  var nonGuiDefault: DefaultValue? { didSet { setDefaultValue("nonGuiDefault", nonGuiDefault) } }
  var objectFilter: ObjectFilter { didSet { UserDefaults.standard.set(objectFilter.rawValue, forKey: "objectFilter") } }
  var reverse: Bool { didSet { UserDefaults.standard.set(reverse, forKey: "reverse") } }
  var showPings: Bool { didSet { UserDefaults.standard.set(showPings, forKey: "showPings") } }
  var showTimes: Bool { didSet { UserDefaults.standard.set(showTimes, forKey: "showTimes") } }
  var smartlinkEmail: String { didSet { UserDefaults.standard.set(smartlinkEmail, forKey: "smartlinkEmail") } }
  var useDefault: Bool { didSet { UserDefaults.standard.set(useDefault, forKey: "useDefault") } }
  
  // other state
  var alertState: AlertState<ApiAction>?
  var clearNow = false
  var clientState: ClientState?
  var commandToSend = ""
  var filteredMessages = IdentifiedArrayOf<TcpMessage>()
  var loginRequired = false
  var forceUpdate = false
  var gotoFirst = false
  var initialized = false
  var loginState: LoginState? = nil
  var messages = IdentifiedArrayOf<TcpMessage>()
  var opusPlayer: OpusPlayer? = nil
  var pickables = IdentifiedArrayOf<Pickable>()
  var pickerState: PickerState? = nil
  var startTime: Date?
  var station: String? = nil
  
  var isStopped = true
    
  public init(
    clearOnSend: Bool  = UserDefaults.standard.bool(forKey: "clearOnSend"),
    clearOnStart: Bool = UserDefaults.standard.bool(forKey: "clearOnStart"),
    clearOnStop: Bool  = UserDefaults.standard.bool(forKey: "clearOnStop"),
    connectionMode: ConnectionMode = ConnectionMode(rawValue: UserDefaults.standard.string(forKey: "connectionMode") ?? "local") ?? .local,
    enableAudio: Bool  = UserDefaults.standard.bool(forKey: "enableAudio"),
    fontSize: CGFloat = UserDefaults.standard.double(forKey: "fontSize") == 0 ? 12 : UserDefaults.standard.double(forKey: "fontSize"),
    guiDefault: DefaultValue? = getDefaultValue("guiDefault"),
    isGui: Bool = UserDefaults.standard.bool(forKey: "isGui"),
    messageFilter: MessageFilter = MessageFilter(rawValue: UserDefaults.standard.string(forKey: "messageFilter") ?? "all") ?? .all,
    messageFilterText: String = UserDefaults.standard.string(forKey: "messageFilterText") ?? "",
    nonGuiDefault: DefaultValue? = getDefaultValue("nonGuiDefault"),
    objectFilter: ObjectFilter = ObjectFilter(rawValue: UserDefaults.standard.string(forKey: "objectFilter") ?? "core") ?? .core,
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
    self.enableAudio = enableAudio
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
  case audioCheckbox(Bool)
  case fontSizeStepper(CGFloat)
  case loginRequiredButton(Bool)
  case messagesPicker(MessageFilter)
  case messagesFilterTextField(String)
  case objectsPicker(ObjectFilter)
  case sendButton(String)
  case startStopButton(Bool)
  case toggle(WritableKeyPath<ApiState, Bool>)
  
  // subview related
  case alertDismissed
  case client(ClientAction)
  case login(LoginAction)
  case picker(PickerAction)
  
  // Effects related
  case loginStatus(Bool, String)
  case showClientSheet(Pickable)
  case showErrorAlert(ConnectionError)
  case showLogAlert(LogEntry)
  case showLoginSheet
  case showPickerSheet(IdentifiedArrayOf<Pickable>)
  case startAudio(RemoteRxAudioStreamId)

  // Subscription related
  case clientEvent(ClientEvent)
  case packetEvent(PacketEvent)
  case tcpMessage(TcpMessage)
  case testResult(TestResult)
}

public struct ApiEnvironment {
  var queue: () -> AnySchedulerOf<DispatchQueue>

  public init(
    queue: @escaping () -> AnySchedulerOf<DispatchQueue> = { .main }
  )
  {
    self.queue = queue
  }
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
          initializeMode(state)
        )
      }
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Actions: ApiView UI controls
      
    case .audioCheckbox(let newState):
      if newState {
        state.enableAudio = true
        if state.isStopped {
          return .none
        } else {
          // start audio
          return .run { [state] send in
            // request a stream
            let id = try await Model.shared.radio!.requestRemoteRxAudioStream()
            // finish audio setup
            await send(.startAudio(id.streamId!))
          }
        }
        
      } else {
        // stop audio
        state.enableAudio = false
        state.opusPlayer?.stop()
        state.opusPlayer = nil
        if state.isStopped == false {
          return .run {send in
            // request removal of the stream
            await StreamModel.shared.removeRemoteRxAudioStream(Model.shared.radio!.connectionHandle)
          }
        } else {
          return .none
        }
      }

    case .clearNowButton:
      state.messages.removeAll()
      state.filteredMessages.removeAll()
      return .none
      
    case .commandTextField(let text):
      state.commandToSend = text
      return .none
      
    case .connectionModePicker(let mode):
      state.connectionMode = mode
      // re-initialize
      return initializeMode(state)
      
    case .fontSizeStepper(let size):
      state.fontSize = size
      return .none
      
    case .loginRequiredButton(let isRequired):
      state.loginRequired.toggle()
      if state.loginRequired {
        // re-initialize the connection mode
        return initializeMode(state)
      }
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
      
    case .startStopButton(_):
      if state.isStopped {
        // ----- START -----
        state.isStopped = false
        if state.clearOnStart {
          state.messages.removeAll()
          state.filteredMessages.removeAll()
        }
        // use the Default?
        return .run { [state] send in
          // get the Pickables
          let pickables = await Api.shared.getPickables(state.isGui, state.guiDefault, state.nonGuiDefault)
          // if using default, is there a default?
          if state.useDefault, let selection = pickables.first(where: { $0.isDefault} ) {
            // YES, default found, check for existing connections
            await send(.showClientSheet(selection))
          } else {
            // NO, open the Picker
            await send(.showPickerSheet(pickables))
          }
        }

      } else {
        // ----- STOP -----
        state.isStopped = true
        if state.clearOnStop {
          state.messages.removeAll()
          state.filteredMessages.removeAll()
        }
        if state.enableAudio {
          // Audio is started, stop it
          state.opusPlayer?.stop()
          state.opusPlayer = nil
          return .run { send in
            await StreamModel.shared.removeRemoteRxAudioStream(Model.shared.radio!.connectionHandle)
            await Api.shared.disconnect()
          }
        } else {
          return .run { send in
            await Api.shared.disconnect()
          }
        }
      }
      
    case .toggle(let keyPath):
      // handles all buttons with a Bool state, EXCEPT LoginRequiredButton and audioCheckbox
      state[keyPath: keyPath].toggle()
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Actions: invoked by other actions
      
    case .loginStatus(let success, let user):
      // a smartlink login was completed
      if success {
        // save the User
        state.smartlinkEmail = user
        state.loginRequired = false
      } else {
        // tell the user it failed
        state.alertState = AlertState(title: TextState("Smartlink login failed for \(user)"))
      }
      return .none
      
    case .showClientSheet(let selection):
      // Gui connection with othe stations?
      if state.isGui && selection.packet.guiClients.count > 0 {
        // YES, may need a disconnect
        var stations = [String]()
        var handles = [Handle]()
        for client in selection.packet.guiClients {
          stations.append(client.station)
          handles.append(client.handle)
        }
        // show the client chooser, let the user choose
        state.clientState = ClientState(selection: selection, stations: stations, handles: handles)
        return .none
        
      } else {
        // not Gui connection or Gui without other stations, attempt to connect
        return connectTo(&state, selection, nil)
      }

    case .showErrorAlert(let error):
      // an error occurred
      state.alertState = AlertState(title: TextState("An Error occurred"), message: TextState(error.rawValue))
      return .none
   
    case .showLoginSheet:
      state.loginState = LoginState(heading: "Smartlink Login Required", user: state.smartlinkEmail)
      return .none
      
    case .showPickerSheet(let pickables):
      // open the Picker sheet
      state.pickerState = PickerState(pickables: pickables, isGui: state.isGui)
      return .none
      
    case .startAudio(let id):
      state.enableAudio = true
      state.opusPlayer = OpusPlayer()
      StreamModel.shared.remoteRxAudioStreams[id: id]?.setDelegate(state.opusPlayer)
      state.opusPlayer!.start()
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Actions: invoked by subscriptions
      
    case .clientEvent(let event):
      // a GuiClient change occurred
      switch event.action {
      case .added:      break
      case .deleted:    break   // FIXME:
      case .completed:
        // if nonGui, is there a clientId for our connected Station?
        if state.isGui == false && event.client.station == state.station {
          // YES, bind to it
          return .run { _ in await Model.shared.radio?.bindToGuiClient(event.client.clientId) }
        }
      }
      return .none
      
    case .packetEvent(_):
      // a packet change occurred
      // is the Picker open?
      if state.pickerState == nil {
        // NO, ignore
        return .none
      } else {
        // YES, update it
        return .run { [state] send in
          // reload the Pickables
          let pickables = await Api.shared.getPickables(state.isGui, state.guiDefault, state.nonGuiDefault)
          await send(.showPickerSheet(pickables))
        }
      }
      
    case .showLogAlert(let logEntry):
      // a Warning or Error has been logged.
      // exit any sheet states
      state.clientState = nil
      state.loginState = nil
      state.pickerState = nil
      // alert the user
      state.alertState = .init(title: TextState("\(logEntry.level == .warning ? "A Warning" : "An Error") was logged:"),
                               message: TextState(logEntry.msg))
      return .none
      
    case .tcpMessage(var tcpMessage):
      // a Tcp Message was sent or received
      // ignore sent "ping" messages unless showPings is true
      if tcpMessage.direction == .sent && tcpMessage.text.contains("ping") && state.showPings == false { return .none }
      // set the time interval
      tcpMessage.timeInterval = tcpMessage.timeStamp.timeIntervalSince(state.startTime!)
      // add the message to the collection
      state.messages.append(tcpMessage)
      // re-filter
      state.filteredMessages = filterMessages(state, state.messageFilter, state.messageFilterText, partial: true, tcpMessage: tcpMessage)
      return .none

    case .testResult(let result):
      // a test result has been received
      state.pickerState?.testResult = result.success
      return .none

      // ----------------------------------------------------------------------------
      // MARK: - Login Actions (LoginView -> ApiView)
      
    case .login(.cancelButton):
      state.loginState = nil
      state.loginRequired = false
      return .none
      
    case .login(.loginButton(let user, let pwd)):
      state.loginState = nil
      // try a Smartlink login
      return .run { send in
        let success = await Api.shared.smartlinkLogin(user, pwd)
        if success {
          let secureStore = SecureStore(service: "Api6000Tester-C")
          _ = secureStore.set(account: "user", data: user)
          _ = secureStore.set(account: "pwd", data: pwd)
        }
        await send(.loginStatus(success, user))
      }
      
    case .login(_):
      // IGNORE ALL OTHER login actions
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Picker Actions (PickerView -> ApiView)
      
    case .picker(.cancelButton):
      state.pickerState = nil
      return .none
      
    case .picker(.connectButton(let selection)):
      // close the Picker sheet
      state.pickerState = nil
      // save the station (if any)
      state.station = selection.station
      // check for other connections
      return Effect(value: .showClientSheet(selection))
      
    case .picker(.defaultButton(let selection)):
      // SET / RESET the default
      if state.isGui {
        // GUI
        let newValue = DefaultValue(selection)
        if state.guiDefault == newValue {
          state.guiDefault = nil
        } else {
          state.guiDefault = newValue
        }
      } else {
        // NONGUI
        let newValue = DefaultValue(selection)
        if state.nonGuiDefault == newValue {
          state.nonGuiDefault = nil
        } else {
          state.nonGuiDefault = newValue
        }
      }
      // redo the Pickables
      return .run { [state] send in
        let pickables = await Api.shared.getPickables(state.isGui, state.guiDefault, state.nonGuiDefault)
        await send(.showPickerSheet(pickables))
      }
      
    case .picker(.testButton(let selection)):
      state.pickerState?.testResult = false
      return .run { send in
        // send a Test request
        await Api.shared.smartlinkTest(for: selection.packet.serial)
      }
      
    case .picker(_):
      // IGNORE ALL OTHER picker actions
      return .none
      
      // ----------------------------------------------------------------------------
      // MARK: - Client Actions (ClientView -> ApiView)
      
    case .client(.cancelButton):
      state.clientState = nil
      return .none
      
    case .client(.connect(let selection, let disconnectHandle)):
      state.clientState = nil
      return connectTo(&state, selection, disconnectHandle)
      
      // ----------------------------------------------------------------------------
      // MARK: - Alert Actions
      
    case .alertDismissed:
      state.alertState = nil
      return .none
    }
  }
)

// ----------------------------------------------------------------------------
// MARK: - Helper methods

func initializeMode(_ state: ApiState) -> Effect<ApiAction, Never> {
  // start / stop listeners as appropriate for the Mode
  return .run { [state] send in
    // set the connection mode, start the Lan and/or Wan listener
    if await Api.shared.setConnectionMode(state.connectionMode, state.smartlinkEmail) {
      if state.loginRequired && (state.connectionMode == .smartlink || state.connectionMode == .both) {
        // Smartlink login is required
        await send(.showLoginSheet)
      }
    } else {
      // Wan listener was required and failed to start
      await send(.showLoginSheet)
    }
  }
}

func connectTo(_ state: inout ApiState, _ selection: Pickable, _ disconnectHandle: Handle?) -> Effect<ApiAction, Never> {
  // attempt to connect to the selected Radio / Station
  state.startTime = Date()
  return .run { [state] send in
    do {
      // try to connect
      try await Api.shared.connectTo(selection: selection,
                                     isGui: state.isGui,
                                     disconnectHandle: disconnectHandle,
                                     station: "Tester",
                                     program: "Api6000Tester")
      if state.isGui && state.enableAudio {
        // start audio, request a stream
        let id = try await Model.shared.radio!.requestRemoteRxAudioStream()
        // finish audio setup
        await send(.startAudio(id.streamId!))
      }
    } catch {
      // connection attempt failed
      await send(.showErrorAlert( error as! ConnectionError ))
    }
  }
}

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

//
// ----------------------------------------------------------------------------
// MARK: - Subscriptions

private func subscribeToPackets() -> Effect<ApiAction, Never> {
  Effect.run { send in
    for await event in await Api.shared.packetStream {
      // a packet has been added / updated or deleted
      await send(.packetEvent(event))
    }
  }
}

private func subscribeToClients() -> Effect<ApiAction, Never> {
  Effect.run { send in
    for await event in await Api.shared.clientStream {
      // a guiClient has been added / updated or deleted
      await send(.clientEvent(event))
    }
  }
}

private func subscribeToMessages() -> Effect<ApiAction, Never> {
  Effect.run { send in
    func ignoreReply(_ text: String) -> Bool {
      if text.first != "R" { return false }     // not a Reply
      let parts = text.components(separatedBy: "|")
      if parts.count < 3 { return false }       // incomplete
      if parts[1] != kNoError { return false }  // error of some type
      if parts[2] != "" { return false }        // additional data present
      return true                               // otherwise, ignore it
    }

    for await tcpMessage in await Api.shared.testerStream {
      // a TCP message was sent or received
      // ignore reply unless it is non-zero or contains additional data
      if tcpMessage.direction == .received && ignoreReply(tcpMessage.text) { continue }
      await send(.tcpMessage(tcpMessage))
    }
  }
}

private func subscribeToSmartlinkTest() -> Effect<ApiAction, Never> {
  Effect.run { send in
    for await result in await Api.shared.testStream {
      // the result of a Smartlink Test has been received
      await send(.testResult(result))
    }
  }
}

private func subscribeToLogAlerts() -> Effect<ApiAction, Never>  {
  Effect.run { send in
#if DEBUG
    for await entry in logAlerts {
      // a Warning or Error has been logged.
      await send(.showLogAlert(entry))
    }
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
