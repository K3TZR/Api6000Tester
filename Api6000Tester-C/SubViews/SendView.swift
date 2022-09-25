//
//  SendView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import SwiftUI
import ComposableArchitecture
import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct SendView: View {
  let store: Store<ApiState, ApiAction>
  @ObservedObject var viewModel: ViewModel

  var body: some View {

    WithViewStore(self.store) { viewStore in
      HStack(spacing: 25) {
        Group {
          Button("Send") { viewStore.send(.sendButton( viewStore.commandToSend )) }
          .keyboardShortcut(.defaultAction)

          HStack(spacing: 0) {
            Image(systemName: "x.circle")
              .onTapGesture {
                viewStore.send(.sendClear)
              }.disabled(viewModel.radio == nil)
            
            Stepper("", onIncrement: {
              viewStore.send(.sendPrevious)
            }, onDecrement: {
              viewStore.send(.sendNext)
            })
            
            TextField("Command to send", text: viewStore.binding(
              get: \.commandToSend,
              send: { value in .commandTextField(value) } ))
          }
        }
        .disabled(viewModel.radio == nil)

        Spacer()
        Toggle("Clear on Send", isOn: viewStore.binding(get: \.clearOnSend, send: .toggle(\.clearOnSend)))
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct SendView_Previews: PreviewProvider {
  static var previews: some View {
    SendView(
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
