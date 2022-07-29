//
//  RadioView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI

// ----------------------------------------------------------------------------
// MARK: - View

struct RadioView: View {
  @ObservedObject var model: Model = Model.shared
  
  var body: some View {
    VStack(alignment: .leading) {
      if model.activePacketId == nil {
        EmptyView()
      } else {
        HStack(spacing: 20) {
          Text(model.packets[id: model.activePacketId!]!.nickname).frame(width: 120, alignment: .leading)
          Text(model.packets[id: model.activePacketId!]!.source.rawValue)
          Text(model.packets[id: model.activePacketId!]!.publicIp)
          Text(model.packets[id: model.activePacketId!]!.version)
          Text(model.packets[id: model.activePacketId!]!.model)
          Text(model.packets[id: model.activePacketId!]!.serial)
          Text(model.packets[id: model.activePacketId!]!.guiClientStations)
          Group {
            Text("Atu \(model.radio!.atuPresent ? "Y" : "N")")
            Text("Gps \(model.radio!.gpsPresent ? "Y" : "N")")
            Text("Scu \(model.radio!.numberOfScus)")
          }
          Spacer()
        }.border(.red)

        //        if model.radio!.atuPresent {  AtuView(store: store) }
        //        if model.radio!.gpsPresent {  GpsView(store: store) }
        .foregroundColor( model.packets[id: model.activePacketId!]!.source == .local ? Color(.systemGreen) : Color(.systemRed))
      }
    }
//    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000


import Shared

struct RadioView_Previews: PreviewProvider {
  static var previews: some View {
    RadioView()
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
