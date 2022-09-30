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
      HStack(spacing: 20) {
        Button(viewStore.isStopped ? "Start" : "Stop") {
          viewStore.send(.startStopButton(viewModel.radio == nil))
        }
        .keyboardShortcut(viewModel.radio == nil ? .defaultAction : .cancelAction)

        HStack(spacing: 20) {
          Toggle("Gui", isOn: viewStore.binding(get: \.isGui, send: .toggle(\.isGui)))
            .disabled(viewModel.radio != nil)
          Toggle("Times", isOn: viewStore.binding(get: \.showTimes, send: .toggle(\.showTimes)))
          Toggle("Pings", isOn: viewStore.binding(get: \.showPings, send: .toggle(\.showPings)))
        }

        Spacer()
        ControlGroup {
          Toggle(isOn: viewStore.binding(get: \.rxAudio, send: { .rxAudioCheckbox($0)} )) {
            Text("Rx Audio") }
          Toggle(isOn: viewStore.binding(get: \.txAudio, send: { .txAudioCheckbox($0)} )) {
            Text("Tx Audio") }
        }.frame(width: 50)

        Spacer()
        ControlGroup {
          Toggle("Local", isOn: viewStore.binding(get: \.local, send: { .localButton($0) } ))
          Toggle("Smartlink", isOn: viewStore.binding(get: \.smartlink, send: { .smartlinkButton($0) } ))
        }
        .frame(width: 75)
        .disabled(viewModel.radio != nil)

        Spacer()
        Toggle("Smartlink Login", isOn: viewStore.binding(get: \.loginRequired, send: { .loginRequiredButton($0) }))
          .disabled(viewModel.radio != nil || viewStore.smartlink == false )
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
