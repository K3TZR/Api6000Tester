//
//  RadioView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct RadioView: View {
  @EnvironmentObject var model: Model
  
  var body: some View {
    if model.activePacketId != nil {
      VStack(alignment: .leading) {
        HStack(spacing: 20) {
          Text("RADIO      ->")
          Text(model.packets[id: model.activePacketId!]!.source.rawValue)
            .foregroundColor(model.packets[id: model.activePacketId!]!.source == .local ? .green : .red)
          Group {
            HStack(spacing: 5) {
              Text("Name")
              Text(model.packets[id: model.activePacketId!]!.nickname)
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)
            }
            HStack(spacing: 5) {
              Text("Ip")
              Text(model.packets[id: model.activePacketId!]!.publicIp).foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("FW Version")
              Text(model.packets[id: model.activePacketId!]!.version).foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Model")
              Text(model.packets[id: model.activePacketId!]!.model).foregroundColor(.secondary)
            }
          }
          Group {
            HStack(spacing: 5) {
              Text("Serial")
              Text(model.packets[id: model.activePacketId!]!.serial).foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Stations")
              Text(model.packets[id: model.activePacketId!]!.guiClientStations).foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Atu")
              Text(model.radio!.atuPresent ? "Y" : "N").foregroundColor(model.radio!.atuPresent ? .green : .red)
            }
            HStack(spacing: 5) {
              Text("Gps")
              Text(model.radio!.gpsPresent ? "Y" : "N").foregroundColor(model.radio!.gpsPresent ? .green : .red)
            }
            HStack(spacing: 5) {
              Text("Scu")
              Text("\(model.radio!.numberOfScus)").foregroundColor(.green)
            }
          }
        }
        AtuView(model: model)
        GpsView(model: model)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct RadioView_Previews: PreviewProvider {
  static var previews: some View {
    RadioView()
      .frame(minWidth: 975)
  }
}
