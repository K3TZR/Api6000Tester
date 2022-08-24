//
//  ApiView.swift
//  Api6000Components/ApiViewer
//
//  Created by Douglas Adams on 12/1/21.
//

import SwiftUI
import ComposableArchitecture

import Api6000
import LoginView
import ClientView
import PickerView
import LogView
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

public struct ApiView: View {
  let store: Store<ApiState, ApiAction>
  
  public init(store: Store<ApiState, ApiAction>) {
    self.store = store
  }
  
  @StateObject var model: Model = Model.shared
  
  public var body: some View {
    
    WithViewStore(self.store) { viewStore in
      
      VStack(alignment: .leading) {
        TopButtonsView(store: store)
        SendView(store: store)
        FiltersView(store: store)

        Divider().background(Color(.gray))

        VSplitView {
          ObjectsView(store: store, model: model)
            .frame(minWidth: 900, maxWidth: .infinity, alignment: .leading)
          Divider().background(Color(.cyan))
          MessagesView(store: store)
            .frame(minWidth: 900, maxWidth: .infinity, alignment: .leading)
        }
        Spacer()
        Divider().background(Color(.gray))
        BottomButtonsView(store: store)
      }
      // initialize on first appearance
      .onAppear() { viewStore.send(.onAppear) }
            
      // alert dialogs
      .alert(
        self.store.scope(state: \.alertState),
        dismiss: .alertDismissed
      )
      
      // Picker sheet
      .sheet(
        isPresented: viewStore.binding(
          get: { $0.pickerState != nil },
          send: ApiAction.picker(.cancelButton)),
        content: {
          IfLetStore(
            store.scope(state: \.pickerState, action: ApiAction.picker),
            then: PickerView.init(store:)
          )
        }
      )
      
      // Login sheet
      .sheet(
        isPresented: viewStore.binding(
          get: { $0.loginState != nil },
          send: ApiAction.login(.cancelButton)),
        content: {
          IfLetStore(
            store.scope(state: \.loginState, action: ApiAction.login),
            then: LoginView.init(store:)
          )
        }
      )
      
      // Client connection sheet
      .sheet(
        isPresented: viewStore.binding(
          get: { $0.clientState != nil },
          send: ApiAction.client(.cancelButton)),
        content: {
          IfLetStore(
            store.scope(state: \.clientState, action: ApiAction.client),
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
