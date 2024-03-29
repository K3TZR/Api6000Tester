//
//  AtuView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI
import ComposableArchitecture

// ----------------------------------------------------------------------------
// MARK: - View

struct AtuView: View {
  let store: Store<ApiState, ApiAction>
  
  var body: some View {
    WithViewStore(store.actionless) { viewStore in
      if viewStore.radio != nil {
        let atu = Model.shared.atu
        HStack(spacing: 20) {
          Text("ATU").padding(.leading, 90)
          Text("Enabled \(atu.enabled ? "Y" : "N")")
          Text("Status \(atu.status)")
          Text("Memories enabled \(atu.memoriesEnabled ? "Y" : "N")")
          Text("Using memories \(atu.usingMemory ? "Y" : "N")")
        }.frame(minWidth: 1000, maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000


import Shared

struct AtuView_Previews: PreviewProvider {
  static var previews: some View {
    AtuView(
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
