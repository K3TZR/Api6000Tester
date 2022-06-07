//
//  PanadapterView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/24/22.
//

import SwiftUI
import ComposableArchitecture

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct PanadapterView: View {
  let store: Store<ApiState, ApiAction>
  let handle: Handle
  let showMeters: Bool
  
  var body: some View {
    WithViewStore(store.actionless) { viewStore in
      ForEach(Model.shared.panadapters) { panadapter in
        if panadapter.clientHandle == handle {
          HStack(spacing: 20) {
            Text("Panadapter").frame(width: 100, alignment: .trailing)
            Text(panadapter.id.hex)
            Text("Center \(panadapter.center)")
            Text("Bandwidth \(panadapter.bandwidth)")
          }
          WaterfallView(store: store, panadapterId: panadapter.id)
          SliceView(store: store, panadapterId: panadapter.id, showMeters: showMeters)
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

struct PanadapterView_Previews: PreviewProvider {
  static var previews: some View {
    PanadapterView(
      store: Store(
        initialState: ApiState(
          radio: Radio(Packet(),
                       connectionType: .gui,
                       command: Tcp(),
                       stream: Udp())
        ),
        reducer: apiReducer,
        environment: ApiEnvironment()
      ),
      handle: 1,
      showMeters: true
    )
    .frame(minWidth: 975)
    .padding()
  }
}
