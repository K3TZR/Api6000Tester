//
//  ApiCore.swift
//  Api6000Components/ApiViewer
//
//  Created by Douglas Adams on 11/24/21.
//

import ComposableArchitecture
import SwiftUI

import Api6000
import ClientFeature
import LoginFeature
import LogFeature
import OpusPlayer
import PickerFeature
import Shared
import SecureStorage
import XCGWrapper

public struct ApiModule: ReducerProtocol {
  
  @Dependency(\.messagesModel) var messagesModel

  public init() {}
  
  public struct State: Equatable {
    // State held in User Defaults
    var clearOnSend: Bool { didSet { UserDefaults.standard.set(clearOnSend, forKey: "clearOnSend") } }
    var clearOnStart: Bool { didSet { UserDefaults.standard.set(clearOnStart, forKey: "clearOnStart") } }
    var clearOnStop: Bool { didSet { UserDefaults.standard.set(clearOnStop, forKey: "clearOnStop") } }
    var guiDefault: DefaultValue? { didSet { setDefaultValue("guiDefault", guiDefault) } }
    var fontSize: CGFloat { didSet { UserDefaults.standard.set(fontSize, forKey: "fontSize") } }
    var isGui: Bool { didSet { UserDefaults.standard.set(isGui, forKey: "isGui") } }
    var local: Bool { didSet { UserDefaults.standard.set(local, forKey: "local") } }
    var messageFilter: MessageFilter { didSet { UserDefaults.standard.set(messageFilter.rawValue, forKey: "messageFilter") } }
    var messageFilterText: String { didSet { UserDefaults.standard.set(messageFilterText, forKey: "messageFilterText") } }
    var nonGuiDefault: DefaultValue? { didSet { setDefaultValue("nonGuiDefault", nonGuiDefault) } }
    var objectFilter: ObjectFilter { didSet { UserDefaults.standard.set(objectFilter.rawValue, forKey: "objectFilter") } }
    var reverse: Bool { didSet { UserDefaults.standard.set(reverse, forKey: "reverse") } }
    var rxAudio: Bool { didSet { UserDefaults.standard.set(rxAudio, forKey: "rxAudio") } }
    var showPings: Bool { didSet { UserDefaults.standard.set(showPings, forKey: "showPings") } }
    var showTimes: Bool { didSet { UserDefaults.standard.set(showTimes, forKey: "showTimes") } }
    var smartlink: Bool { didSet { UserDefaults.standard.set(smartlink, forKey: "smartlink") } }
    var smartlinkEmail: String { didSet { UserDefaults.standard.set(smartlinkEmail, forKey: "smartlinkEmail") } }
    var txAudio: Bool { didSet { UserDefaults.standard.set(txAudio, forKey: "txAudio") } }
    var useDefault: Bool { didSet { UserDefaults.standard.set(useDefault, forKey: "useDefault") } }
    
    // other state
    var clearNow = false
    var commandToSend = ""
    var loginRequired = false
    var forceUpdate = false
    var gotoFirst = false
    var initialized = false
    var isStopped = true
    var opusPlayer: OpusPlayer? = nil
    var pickables = IdentifiedArrayOf<Pickable>()
    var station: String? = nil

    // subview state
    var alertState: AlertState<ApiModule.Action>?
    var clientState: ClientFeature.State?
    var loginState: LoginFeature.State? = nil
    var pickerState: PickerFeature.State? = nil

    
    var previousCommand = ""
    var commandsIndex = 0
    var commandsArray = [""]
    
    public init(
      clearOnSend: Bool  = UserDefaults.standard.bool(forKey: "clearOnSend"),
      clearOnStart: Bool = UserDefaults.standard.bool(forKey: "clearOnStart"),
      clearOnStop: Bool  = UserDefaults.standard.bool(forKey: "clearOnStop"),
      fontSize: CGFloat = UserDefaults.standard.double(forKey: "fontSize") == 0 ? 12 : UserDefaults.standard.double(forKey: "fontSize"),
      guiDefault: DefaultValue? = getDefaultValue("guiDefault"),
      isGui: Bool = UserDefaults.standard.bool(forKey: "isGui"),
      local: Bool = UserDefaults.standard.bool(forKey: "local"),
      messageFilter: MessageFilter = MessageFilter(rawValue: UserDefaults.standard.string(forKey: "messageFilter") ?? "all") ?? .all,
      messageFilterText: String = UserDefaults.standard.string(forKey: "messageFilterText") ?? "",
      nonGuiDefault: DefaultValue? = getDefaultValue("nonGuiDefault"),
      objectFilter: ObjectFilter = ObjectFilter(rawValue: UserDefaults.standard.string(forKey: "objectFilter") ?? "core") ?? .core,
      reverse: Bool = UserDefaults.standard.bool(forKey: "reverse"),
      rxAudio: Bool  = UserDefaults.standard.bool(forKey: "rxAudio"),
      showPings: Bool = UserDefaults.standard.bool(forKey: "showPings"),
      showTimes: Bool = UserDefaults.standard.bool(forKey: "showTimes"),
      smartlink: Bool = UserDefaults.standard.bool(forKey: "smartlink"),
      smartlinkEmail: String = UserDefaults.standard.string(forKey: "smartlinkEmail") ?? "",
      txAudio: Bool  = UserDefaults.standard.bool(forKey: "txAudio"),
      useDefault: Bool = UserDefaults.standard.bool(forKey: "useDefault")
    )
    {
      self.clearOnStart = clearOnStart
      self.clearOnStop = clearOnStop
      self.clearOnSend = clearOnSend
      self.guiDefault = guiDefault
      self.fontSize = fontSize
      self.isGui = isGui
      self.local = local
      self.messageFilter = messageFilter
      self.messageFilterText = messageFilterText
      self.nonGuiDefault = nonGuiDefault
      self.objectFilter = objectFilter
      self.reverse = reverse
      self.rxAudio = rxAudio
      self.showPings = showPings
      self.showTimes = showTimes
      self.smartlink = smartlink
      self.smartlinkEmail = smartlinkEmail
      self.txAudio = txAudio
      self.useDefault = useDefault
    }
  }
    
  public enum Action: Equatable {
    // initialization
    case onAppear
    
    // UI controls
    case clearNowButton
    case commandTextField(String)
    case fontSizeStepper(CGFloat)
    case localButton(Bool)
    case loginRequiredButton(Bool)
    case messagesFilterTextField(String)
    case messagesFilterPicker(MessageFilter)
    case objectsPicker(ObjectFilter)
    case rxAudioButton(Bool)
    case saveButton
    case sendButton(String)
    case sendClearButton
    case sendNextStepper
    case sendPreviousStepper
    case smartlinkButton(Bool)
    case startStopButton(Bool)
    case toggle(WritableKeyPath<ApiModule.State, Bool>)
    case txAudioButton(Bool)
    
    // subview related
    case alertDismissed
    case client(ClientFeature.Action)
    case login(LoginFeature.Action)
    case picker(PickerFeature.Action)
    
    // Effects related
    case checkConnectionStatus(Pickable)
    case connect(Pickable, UInt32?)
    case loginStatus(Bool, String)
    case startRxAudio(RemoteRxAudioStreamId)
    
    // Sheet related
    case showClientSheet(Pickable, [String], [UInt32])
    case showErrorAlert(ConnectionError)
    case showLogAlert(LogEntry)
    case showLoginSheet
    case showPickerSheet(IdentifiedArrayOf<Pickable>)

    // Subscription related
    case clientEvent(ClientEvent)
    case packetEvent(PacketEvent)
    case testResult(TestResult)
  }
  
  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      // Parent logic
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
            subscribeToLogAlerts(),
            subscribeToSmartlinkTest(),
            initializeMode(state)
          )
        }
        return .none
        
        // ----------------------------------------------------------------------------
        // MARK: - Actions: ApiView UI controls
        
      case .clearNowButton:
        return .run { send in
          await messagesModel.clear()
        }
        
      case .commandTextField(let text):
        state.commandToSend = text
        return .none
        
      case .fontSizeStepper(let size):
        state.fontSize = size
        return .none
        
      case .localButton(let newState):
        state.local = newState
        return initializeMode(state)
        
      case .loginRequiredButton(_):
        state.loginRequired.toggle()
        if state.loginRequired {
          // re-initialize the connection mode
          return initializeMode(state)
        }
        return .none
        
      case .messagesFilterTextField(let text):
        return .run { _ in
          await messagesModel.setFilterText(text)
          await messagesModel.filterMessages()
        }
        
      case .messagesFilterPicker(let filter):
        return .run { _ in
          await messagesModel.setFilter(filter)
          await messagesModel.filterMessages()
        }
        
      case .objectsPicker(let newFilter):
        state.objectFilter = newFilter
        return .none
        
      case .rxAudioButton(let newState):
        if newState {
          state.rxAudio = true
          if state.isStopped {
            return .none
          } else {
            // start audio
            return .run { send in
              // request a stream
              let id = try await ViewModel.shared.radio!.requestRemoteRxAudioStream()
              // finish audio setup
              await send(.startRxAudio(id.streamId!))
            }
          }
          
        } else {
          // stop audio
          state.rxAudio = false
          state.opusPlayer?.stop()
          state.opusPlayer = nil
          if state.isStopped == false {
            return .run {send in
              // request removal of the stream
              await StreamModel.shared.removeRemoteRxAudioStream(ViewModel.shared.radio!.connectionHandle)
            }
          } else {
            return .none
          }
        }
        
      case .saveButton:
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "Api6000Tester-C.messages"
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = "Save the Log"
        
        let response = savePanel.runModal()
        if response == .OK {
          return .run { _ in
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 6
            formatter.positiveFormat = " * ##0.000000"

          let textArray = await messagesModel.filteredMessages.map { formatter.string(from: NSNumber(value: $0.interval))! + " " + $0.text }
            let fileTextArray = textArray.joined(separator: "\n")
            try? await fileTextArray.write(to: savePanel.url!, atomically: true, encoding: .utf8)
          }
        }
        return .none
        
      case .sendButton(let command):
        // update the command history
        if command != state.previousCommand { state.commandsArray.append(command) }
        state.previousCommand = command
        state.commandsIndex = state.commandsIndex + 1
        
        if state.clearOnSend {
          state.commandToSend = ""
          state.commandsIndex = 0
        }
        return .run { send in
          _ = await ViewModel.shared.radio?.send(command)
        }
        
      case .sendClearButton:
        state.commandToSend = ""
        state.commandsIndex = 0
        return .none
        
      case .sendNextStepper:
        if state.commandsIndex == state.commandsArray.count - 1{
          state.commandsIndex = 0
        } else {
          state.commandsIndex += 1
        }
        state.commandToSend = state.commandsArray[state.commandsIndex]
        return .none
        
      case .sendPreviousStepper:
        if state.commandsIndex == 0 {
          state.commandsIndex = state.commandsArray.count - 1
        } else {
          state.commandsIndex -= 1
        }
        state.commandToSend = state.commandsArray[state.commandsIndex]
        return .none
        
      case .smartlinkButton(let newState):
        state.smartlink = newState
        return initializeMode(state)
        
      case .startStopButton(_):
        if state.isStopped {
          // ----- START -----
          state.isStopped = false
          // use the Default?
          return .run { [state] send in
            if state.clearOnStart {
              //          state.messages.removeAll()
              //          state.filteredMessages.removeAll()
              await messagesModel.clear()
            }
            // get the Pickables
            let pickables = await PacketModel.shared.getPickables(state.isGui, state.guiDefault, state.nonGuiDefault)
            // if using default, is there a default?
            if state.useDefault, let selection = pickables.first(where: { $0.isDefault} ) {
              // YES, default found, check for existing connections
              await send(.checkConnectionStatus(selection))
            } else {
              // NO, open the Picker
              await send(.showPickerSheet(pickables))
            }
          }
          
        } else {
          // ----- STOP -----
          state.isStopped = true
          if state.rxAudio {
            // Audio is started, stop it
            state.opusPlayer?.stop()
            state.opusPlayer = nil
            return .run { [state] send in
              if state.clearOnStop {
                //          state.messages.removeAll()
                //          state.filteredMessages.removeAll()
                await messagesModel.clear()
              }
              await StreamModel.shared.removeRemoteRxAudioStream(ViewModel.shared.radio!.connectionHandle)
              await Api.shared.disconnect()
            }
          } else {
            return .run {[state] send in
              if state.clearOnStop {
                //          state.messages.removeAll()
                //          state.filteredMessages.removeAll()
                await messagesModel.clear()
              }
              await Api.shared.disconnect()
            }
          }
        }
        
      case .toggle(let keyPath):
        // handles all buttons with a Bool state, EXCEPT LoginRequiredButton and audioCheckbox
        state[keyPath: keyPath].toggle()
        return .none
        
      case .txAudioButton(let newState):
        if newState {
          state.txAudio = true
          if state.isStopped {
            return .none
          } else {
            // start audio
            return .run { send in
              // request a stream
              let id = try await ViewModel.shared.radio!.requestRemoteTxAudioStream()
              
              // FIXME:
              
              // finish audio setup
              //            await send(.startAudio(id.streamId!))
            }
          }
          
        } else {
          // stop audio
          state.txAudio = false
          //        state.opusPlayer?.stop()
          //        state.opusPlayer = nil
          if state.isStopped == false {
            return .run { send in
              // request removal of the stream
              await StreamModel.shared.removeRemoteTxAudioStream(ViewModel.shared.radio!.connectionHandle)
            }
          } else {
            return .none
          }
        }
        
        // ----------------------------------------------------------------------------
        // MARK: - Actions: invoked by other actions
                
      case .checkConnectionStatus(let selection):
        return .run { [state] send in
          // Gui connection with othe stations?
          let count = await PacketModel.shared.guiClients.count
          if state.isGui && count > 0 {
            // YES, may need a disconnect
            var stations = [String]()
            var handles = [Handle]()
            for client in await PacketModel.shared.guiClients {
              stations.append(client.station)
              handles.append(client.handle)
            }
            // show the client chooser, let the user choose
            await send(.showClientSheet(selection, stations, handles))
          }
          else {
            // not Gui connection or Gui without other stations, attempt to connect
            await send(.connect(selection, nil))
          }
        }
        
      case .connect(let selection, let disconnectHandle):
        state.clientState = nil
        return .run { [state] send in
          await messagesModel.start()
          // attempt to connect to the selected Radio / Station
          do {
            // try to connect
            try await Api.shared.connectTo(selection: selection,
                                           isGui: state.isGui,
                                           disconnectHandle: disconnectHandle,
                                           station: "Tester",
                                           program: "Api6000Tester")
            if state.isGui && state.rxAudio {
              // start audio, request a stream
              let id = try await ViewModel.shared.radio!.requestRemoteRxAudioStream()
              // finish audio setup
              await send(.startRxAudio(id.streamId!))
            }
          } catch {
            // connection attempt failed
            await send(.showErrorAlert( error as! ConnectionError ))
          }
        }

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
        
      case .startRxAudio(let id):
        state.rxAudio = true
        state.opusPlayer = OpusPlayer()
        StreamModel.shared.remoteRxAudioStreams[id: id]?.setDelegate(state.opusPlayer)
        state.opusPlayer!.start()
        return .none
        
        // ----------------------------------------------------------------------------
        // MARK: - Actions: to display a sheet
        
      case .showClientSheet(let selection, let stations, let handles):
        // show the client chooser, let the user choose
        state.clientState = ClientFeature.State(selection: selection, stations: stations, handles: handles)
        return .none
        
      case .showErrorAlert(let error):
        // an error occurred
        state.alertState = AlertState(title: TextState("An Error occurred"), message: TextState(error.rawValue))
        return .none
        
      case .showLoginSheet:
        state.loginState = LoginFeature.State(heading: "Smartlink Login Required", user: state.smartlinkEmail)
        return .none
        
      case .showPickerSheet(let pickables):
        // open the Picker sheet
        state.pickerState = PickerFeature.State(pickables: pickables, isGui: state.isGui)
        return .none
        
        // ----------------------------------------------------------------------------
        // MARK: - Actions: invoked by subscriptions
        
      case .clientEvent(let event):
        // a GuiClient change occurred
        switch event.action {
        case .added:      break
          
        case .removed:
          // if nonGui, is it our connected Station?
          if state.isGui == false && event.client.station == state.station {
            // YES, unbind
            return .run { _ in
              await ViewModel.shared.setActiveStation( nil )
              await ViewModel.shared.radio?.bindToGuiClient(nil) }
          }
          
        case .completed:
          // if nonGui, is there a clientId for our connected Station?
          if state.isGui == false && event.client.station == state.station {
            // YES, bind to it
            return .run { _ in
              print("----->", event.client.station)
              await ViewModel.shared.setActiveStation( event.client.station )
              await ViewModel.shared.radio?.bindToGuiClient(event.client.clientId) }
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
            let pickables = await PacketModel.shared.getPickables(state.isGui, state.guiDefault, state.nonGuiDefault)
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
        
      case .testResult(let result):
        // a test result has been received
        state.pickerState?.testResult = result.success
        return .none
        
        // ----------------------------------------------------------------------------
        // MARK: - Login Actions (LoginFeature -> ApiView)
        
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
        // MARK: - Picker Actions (PickerFeature -> ApiView)
        
      case .picker(.cancelButton):
        state.pickerState = nil
        state.isStopped = true
        return .none
        
      case .picker(.connectButton(let selection)):
        // close the Picker sheet
        state.pickerState = nil
        // save the station (if any)
        state.station = selection.station
        // check for other connections
        return Effect(value: .checkConnectionStatus(selection))
        
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
          let pickables = await PacketModel.shared.getPickables(state.isGui, state.guiDefault, state.nonGuiDefault)
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
        // MARK: - Client Actions (ClientFeature -> ApiView)
        
      case .client(.cancelButton):
        state.clientState = nil
        return .none
        
      case .client(.connect(let selection, let disconnectHandle)):
        state.clientState = nil
        return .run { send in
          await send (.connect(selection, disconnectHandle))
        }
        
        // ----------------------------------------------------------------------------
        // MARK: - Alert Actions
        
      case .alertDismissed:
        state.alertState = nil
        return .none
      }
    }
    // ClientModule logic
    .ifLet(\.clientState, action: /Action.client) {
      ClientFeature()
    }
    // LoginModule logic
    .ifLet(\.loginState, action: /Action.login) {
      LoginFeature()
    }
    // PickerModule logic
    .ifLet(\.pickerState, action: /Action.picker) {
      PickerFeature()
    }
  }
}
  
// ----------------------------------------------------------------------------
// MARK: - Effects

func initializeMode(_ state: ApiModule.State) -> Effect<ApiModule.Action, Never> {
  // start / stop listeners as appropriate for the Mode
  return .run { [state] send in
    // set the connection mode, start the Lan and/or Wan listener
    if await Api.shared.setConnectionMode(state.local, state.smartlink, state.smartlinkEmail) {
      if state.loginRequired && state.smartlink {
        // Smartlink login is required
        await send(.showLoginSheet)
      }
    } else {
      // Wan listener was required and failed to start
      await send(.showLoginSheet)
    }
  }
}

private func subscribeToClients() -> Effect<ApiModule.Action, Never> {
  Effect.run { send in
    for await event in await PacketModel.shared.clientStream {
      // a guiClient has been added / updated or deleted
      await send(.clientEvent(event))
    }
  }
}

private func subscribeToLogAlerts() -> Effect<ApiModule.Action, Never>  {
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

private func subscribeToPackets() -> Effect<ApiModule.Action, Never> {
  Effect.run { send in
    for await event in await PacketModel.shared.packetStream {
      // a packet has been added / updated or deleted
      await send(.packetEvent(event))
    }
  }
}

private func subscribeToSmartlinkTest() -> Effect<ApiModule.Action, Never> {
  Effect.run { send in
    for await result in await Api.shared.testStream {
      // the result of a Smartlink Test has been received
      await send(.testResult(result))
    }
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
  case misc
  case profiles
  case meters
  case network
  case streams
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
