//
//  ApiView.swift
//  Api6000Components/ApiViewer
//
//  Created by Douglas Adams on 12/1/21.
//

import SwiftUI
import ComposableArchitecture

import LoginView
import ClientView
import PickerView
import LogView
import RemoteView
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

public struct ApiView: View {
  let store: Store<ApiState, ApiAction>
  
  public init(store: Store<ApiState, ApiAction>) {
    self.store = store
  }
  
  public var body: some View {
    
    WithViewStore(self.store) { viewStore in
      
      VStack(alignment: .leading) {
        TopButtonsView(store: store)
        SendView(store: store)
        FiltersView(store: store)
        
        Divider().background(Color(.red))
        
        VSplitView {
          ObjectsView(store: store)
          Divider().background(Color(.green))
          MessagesView(store: store)
        }
        Spacer()
        Divider().background(Color(.red))
        BottomButtonsView(store: store)
      }
      // initialize on first appearance
      .onAppear() { viewStore.send(.onAppear) }
      
      // alert dialogs
      .alert(
        self.store.scope(state: \.alert),
        dismiss: .alertDismissed
      )
      
      // Picker sheet
      .sheet(
        isPresented: viewStore.binding(
          get: { $0.pickerState != nil },
          send: ApiAction.pickerAction(.cancelButton)),
        content: {
          IfLetStore(
            store.scope(state: \.pickerState, action: ApiAction.pickerAction),
            then: PickerView.init(store:)
          )
        }
      )
      
      // Login sheet
      .sheet(
        isPresented: viewStore.binding(
          get: { $0.loginState != nil },
          send: ApiAction.loginAction(.cancelButton)),
        content: {
          IfLetStore(
            store.scope(state: \.loginState, action: ApiAction.loginAction),
            then: LoginView.init(store:)
          )
        }
      )
      
      // Connection sheet
      .sheet(
        isPresented: viewStore.binding(
          get: { $0.clientState != nil },
          send: ApiAction.clientAction(.cancelButton)),
        content: {
          IfLetStore(
            store.scope(state: \.clientState, action: ApiAction.clientAction),
            then: ClientView.init(store:)
          )
        }
      )
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct ApiView_Previews: PreviewProvider {
  static var previews: some View {
    ApiView(
      store: Store(
        initialState: ApiState(),
        reducer: apiReducer,
        environment: ApiEnvironment()
      )
    )
    .frame(minWidth: 975, minHeight: 400)
    .padding()
  }
}
