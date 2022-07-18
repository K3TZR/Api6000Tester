//
//  NonGuiClientView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/25/22.
//

import SwiftUI
import ComposableArchitecture

// ----------------------------------------------------------------------------
// MARK: - View

struct NonGuiClientView: View {
  let store: Store<ApiState, ApiAction>
  
  var body: some View {
    WithViewStore(store.actionless) { viewStore in
      if viewStore.radio != nil {
        VStack(alignment: .leading) {
          Divider().foregroundColor(Color(.systemRed))
          HStack(spacing: 20) {
            Text("NONGUI CLIENT -> ").frame(width: 140, alignment: .leading)
            Text("Api6000Tester / Mac").frame(width: 220, alignment: .leading)
            Text("Handle \(viewStore.radio!.connectionHandle?.hex ?? "")")
            Text("Bound to \(viewStore.radio!.boundClientId ?? "")")
          }
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000


import Shared

struct NonGuiClientView_Previews: PreviewProvider {
  static var previews: some View {
    NonGuiClientView(
      store: Store(
        initialState: ApiState(
          radio: Radio(Packet(),
                       connectionType: .gui,
                       command: Tcp(),
                       stream: Udp())
        ),
        reducer: apiReducer,
        environment: ApiEnvironment()
      )
    )
    .frame(minWidth: 975)
    .padding()
  }
}
