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
  @ObservedObject var model: Model

 public  var body: some View {

    WithViewStore(self.store) { viewStore in
      HStack(spacing: 30) {
        Button(model.radio == nil ? "Start" : "Stop") {
          viewStore.send(.startStopButton)
        }
        .keyboardShortcut(model.radio == nil ? .defaultAction : .cancelAction)

        HStack(spacing: 20) {
          Toggle("Gui", isOn: viewStore.binding(get: \.isGui, send: .toggle(\.isGui)))
            .disabled(model.radio != nil)
          Toggle("Times", isOn: viewStore.binding(get: \.showTimes, send: .toggle(\.showTimes)))
          Toggle("Pings", isOn: viewStore.binding(get: \.showPings, send: .toggle(\.showPings)))
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
        .disabled(model.radio != nil)
        .labelsHidden()
        .frame(width: 200)

        Spacer()
        Toggle("Force Smartlink Login", isOn: viewStore.binding(get: \.forceWanLogin, send: .toggle(\.forceWanLogin)))
          .disabled(model.radio != nil || viewStore.connectionMode == .local || viewStore.connectionMode == .none)
        Toggle("Use Default", isOn: viewStore.binding(get: \.useDefault, send: .toggle(\.useDefault)))
          .disabled(model.radio != nil)
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
      ), model: Model.shared
    )
      .frame(minWidth: 975)
      .padding()
  }
}
