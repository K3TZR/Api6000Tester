//
//  TopButtonsView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import ComposableArchitecture
import SwiftUI

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

public struct TopButtonsView: View {
  let store: StoreOf<ApiModule>
//  @ObservedObject var viewModel: ViewModel
  
  
  
  struct ViewState: Equatable {
    let isStopped: Bool
    let isGui: Bool
    let showTimes: Bool
    let showPings: Bool
    let rxAudio: Bool
    let txAudio: Bool
    let local: Bool
    let smartlink: Bool
    let loginRequired: Bool
    let useDefault: Bool
    init(state: ApiModule.State) {
      self.isStopped = state.isStopped
      self.isGui = state.isGui
      self.showTimes = state.showTimes
      self.showPings = state.showPings
      self.rxAudio = state.rxAudio
      self.txAudio = state.txAudio
      self.local = state.local
      self.smartlink = state.smartlink
      self.loginRequired = state.loginRequired
      self.useDefault = state.useDefault
    }
  }

  
  
  
  
  
  

 public  var body: some View {

   WithViewStore(self.store, observe: ViewState.init) { viewStore in
      HStack(spacing: 20) {
        Button(viewStore.isStopped ? "Start" : "Stop") {
          viewStore.send(.startStopButton)
        }
        .keyboardShortcut(viewStore.isStopped ? .defaultAction : .cancelAction)

        HStack(spacing: 20) {
          Group {
            Toggle("Gui", isOn: viewStore.binding(get: \.isGui, send: .toggle(\ApiModule.State.isGui)))
              .disabled( !viewStore.isStopped )
            Toggle("Times", isOn: viewStore.binding(get: \.showTimes, send: .toggle(\ApiModule.State.showTimes)))
            Toggle("Pings", isOn: viewStore.binding(get: \.showPings, send: .toggle(\ApiModule.State.showPings)))
          }
          .frame(width: 60)
        }

        Spacer()
        ControlGroup {
          Toggle(isOn: viewStore.binding(get: \.rxAudio, send: { .rxAudioButton($0)} )) {
            Text("Rx Audio") }
          Toggle(isOn: viewStore.binding(get: \.txAudio, send: { .txAudioButton($0)} )) {
            Text("Tx Audio") }
        }
        .frame(width: 150)

        Spacer()
        ControlGroup {
          Toggle("Local", isOn: viewStore.binding(get: \.local, send: { .localButton($0) } ))
          Toggle("Smartlink", isOn: viewStore.binding(get: \.smartlink, send: { .smartlinkButton($0) } ))
        }
        .frame(width: 150)
        .disabled( !viewStore.isStopped )

        Spacer()
        Toggle("Smartlink Login", isOn: viewStore.binding(get: \.loginRequired, send: { .loginRequiredButton($0) }))
          .disabled( !viewStore.isStopped || viewStore.smartlink == false )
        Toggle("Use Default", isOn: viewStore.binding(get: \.useDefault, send: .toggle(\ApiModule.State.useDefault)))
          .disabled( !viewStore.isStopped )
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct TopButtonsView_Previews: PreviewProvider {
  static var previews: some View {
    TopButtonsView(
      store: Store(
        initialState: ApiModule.State(),
        reducer: ApiModule()
      )
//      , viewModel: ViewModel.shared
    )
      .frame(minWidth: 975)
      .padding()
  }
}
