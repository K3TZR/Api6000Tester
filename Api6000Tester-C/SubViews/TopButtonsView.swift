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
  @ObservedObject var viewModel: ViewModel

 public  var body: some View {

   WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(spacing: 20) {
        Button(viewStore.isStopped ? "Start" : "Stop") {
          viewStore.send(.startStopButton(viewModel.radio == nil))
        }
        .keyboardShortcut(viewModel.radio == nil ? .defaultAction : .cancelAction)

        HStack(spacing: 20) {
          Group {
            Toggle("Gui", isOn: viewStore.binding(get: \.isGui, send: .toggle(\ApiModule.State.isGui)))
              .disabled(viewModel.radio != nil)
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
        .disabled(viewModel.radio != nil)

        Spacer()
        Toggle("Smartlink Login", isOn: viewStore.binding(get: \.loginRequired, send: { .loginRequiredButton($0) }))
          .disabled(viewModel.radio != nil || viewStore.smartlink == false )
        Toggle("Use Default", isOn: viewStore.binding(get: \.useDefault, send: .toggle(\ApiModule.State.useDefault)))
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
        initialState: ApiModule.State(),
        reducer: ApiModule()
      ), viewModel: ViewModel.shared
    )
      .frame(minWidth: 975)
      .padding()
  }
}
