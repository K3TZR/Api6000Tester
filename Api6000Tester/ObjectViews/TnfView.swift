//
//  TnfView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI
import ComposableArchitecture

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct TnfView: View {
  let store: Store<ApiState, ApiAction>
  
  var body: some View {
    WithViewStore(store.actionless) { viewStore in
      if viewStore.radio != nil {
//        let tnfs = Array(viewStore.viewModel.tnfs)

        ForEach(Array(Model.shared.tnfs)) { tnf in
          HStack(spacing: 20) {
            Text("Tnf").frame(width: 100, alignment: .trailing)
            Text(String(format: "%d", tnf.id))
            Text("Frequency \(tnf.frequency)")
            Text("Width \(tnf.width)")
            Text("Depth \(tnf.depth)")
            Text("Permanent \(tnf.permanent ? "Y" : "N")")
          }
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000
import TcpCommands
import UdpStreams
import Shared

struct TnfView_Previews: PreviewProvider {
  static var previews: some View {
    TnfView(
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
