//
//  RadioView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI
import ComposableArchitecture

// ----------------------------------------------------------------------------
// MARK: - View

struct RadioView: View {
  let store: Store<ApiState, ApiAction>
  
  var body: some View {
    WithViewStore(store.actionless) { viewStore in
      VStack(alignment: .leading) {
        HStack(spacing: 20) {
          Text(viewStore.radio!.packet.nickname).frame(width: 120, alignment: .leading)
          Text(viewStore.radio!.packet.source.rawValue)
          Text(viewStore.radio!.packet.publicIp)
          Text(viewStore.radio!.packet.status)
          Text(viewStore.radio!.packet.version)
          Text(viewStore.radio!.packet.model)
          Text(viewStore.radio!.packet.serial)
          Group {
            Text("Atu \(viewStore.radio!.atuPresent ? "Y" : "N")")
            Text("Gps \(viewStore.radio!.gpsPresent ? "Y" : "N")")
            Text("Scu \(viewStore.radio!.numberOfScus)")
          }
        }
        if viewStore.radio!.atuPresent {  AtuView(store: store) }
        if viewStore.radio!.gpsPresent {  GpsView(store: store) }
      }
      .foregroundColor( viewStore.radio!.packet.source == .local ? Color(.systemGreen) : Color(.systemRed))
      .frame(alignment: .leading)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000


import Shared

struct RadioView_Previews: PreviewProvider {
  static var previews: some View {
    RadioView(
      store: Store(
        initialState: ApiState(
          radio: Radio(testPacket,
                       connectionType: .gui,
                       command: Tcp(),
                       stream: Udp())
        ),
        reducer: apiReducer,
        environment: ApiEnvironment()
      )
    )
      .frame(minWidth: 975)
  }
}

var testPacket: Packet {
  
  var packet = Packet()
  packet.nickname = "Dougs Flex"
  packet.model = "Flex-6500"
  packet.status = "Available"
  packet.source = .local
  packet.publicIp = "10.0.1.200"
  packet.serial = "1234-5678-9012-3456"
  packet.version = "3.2.5.1234"
  return packet
}
