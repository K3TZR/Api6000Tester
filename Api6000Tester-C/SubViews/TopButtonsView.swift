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
  let store: Store<ApiState, ApiAction>
  @ObservedObject var viewModel: ViewModel

 public  var body: some View {

    WithViewStore(self.store) { viewStore in
      HStack(spacing: 30) {
        Button(viewStore.isStopped ? "Start" : "Stop") {
          viewStore.send(.startStopButton(viewModel.radio == nil))
        }
        .keyboardShortcut(viewModel.radio == nil ? .defaultAction : .cancelAction)

        HStack(spacing: 20) {
          Toggle("Gui", isOn: viewStore.binding(get: \.isGui, send: .toggle(\.isGui)))
            .disabled(viewModel.radio != nil)
          Toggle("Times", isOn: viewStore.binding(get: \.showTimes, send: .toggle(\.showTimes)))
          Toggle("Pings", isOn: viewStore.binding(get: \.showPings, send: .toggle(\.showPings)))
          Toggle("Audio", isOn: viewStore.binding(get: \.enableAudio, send: { .audioCheckbox($0)} ))
            .disabled(viewStore.isGui == false)
        }

        Spacer()
        Picker("", selection: viewStore.binding(
          get: \.connectionMode,
          send: { .connectionModePicker($0) }
        )) {
          Text("Local").tag(ConnectionMode.local)
          Text("Smartlink").tag(ConnectionMode.smartlink)
          Text("Both").tag(ConnectionMode.both)
          Text("None").tag(ConnectionMode.none)
        }
        .pickerStyle(.segmented)
        .disabled(viewModel.radio != nil)
        .labelsHidden()
        .frame(width: 200)

        Spacer()
        Toggle("Smartlink Login", isOn: viewStore.binding(get: \.loginRequired, send: { .loginRequiredButton($0) }))
          .disabled(viewModel.radio != nil || viewStore.connectionMode == .local || viewStore.connectionMode == .none)
        Toggle("Use Default", isOn: viewStore.binding(get: \.useDefault, send: .toggle(\.useDefault)))
          .disabled(viewModel.radio != nil)
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
        initialState: ApiState(),
        reducer: apiReducer,
        environment: ApiEnvironment()
      ), viewModel: ViewModel.shared
    )
      .frame(minWidth: 975)
      .padding()
  }
}
