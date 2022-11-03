//
//  SendView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import ComposableArchitecture
import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct SendView: View {
  let store: StoreOf<ApiModule>
//  @ObservedObject var viewModel: ViewModel
  
  
  
  
  struct ViewState: Equatable {
    let clearOnSend: Bool
    let commandToSend: String
    let isStopped: Bool
    init(state: ApiModule.State) {
      self.clearOnSend = state.clearOnSend
      self.commandToSend = state.commandToSend
      self.isStopped = state.isStopped
    }
  }

  
  
  
  
  
  
  
  var body: some View {

    WithViewStore(self.store, observe: ViewState.init) { viewStore in
      HStack(spacing: 25) {
        Group {
          Button("Send") { viewStore.send(.sendButton( viewStore.commandToSend )) }
          .keyboardShortcut(.defaultAction)

          HStack(spacing: 0) {
            Image(systemName: "x.circle")
              .onTapGesture {
                viewStore.send(.sendClearButton)
              }
            
            Stepper("", onIncrement: {
              viewStore.send(.sendPreviousStepper)
            }, onDecrement: {
              viewStore.send(.sendNextStepper)
            })
            
            TextField("Command to send", text: viewStore.binding(
              get: \.commandToSend,
              send: { value in .commandTextField(value) } ))
          }
        }
        .disabled(viewStore.isStopped)

        Spacer()
        Toggle("Clear on Send", isOn: viewStore.binding(get: \.clearOnSend, send: .toggle(\ApiModule.State.clearOnSend)))
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
        initialState: ApiModule.State(),
        reducer: ApiModule()
      )
//      , viewModel: ViewModel.shared
    )
      .frame(minWidth: 975)
      .padding()
  }
}
