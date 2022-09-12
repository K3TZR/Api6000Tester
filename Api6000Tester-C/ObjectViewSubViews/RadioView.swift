//
//  RadioView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI
import ComposableArchitecture

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct RadioView: View {
  let store: Store<ApiState, ApiAction>
  @ObservedObject var model: Model
  
  var body: some View {
    
    WithViewStore(store) { viewStore in
      if model.activePacketId != nil {
        VStack(alignment: .leading) {
          HStack(spacing: 10) {
            Group {
              
              HStack(spacing: 0) {
                Text("RADIO   ").foregroundColor(.blue)
                Text(model.packets[id: model.activePacketId!]!.source.rawValue)
                  .foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("Name")
                Text(model.packets[id: model.activePacketId!]!.nickname)
                  .foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("Ip")
                Text(model.packets[id: model.activePacketId!]!.publicIp).foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("FW")
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
              }.frame(width: 150, alignment: .leading)

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
        }
        AtuView(model: model)
        GpsView(model: model)
        TnfView(model: model)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct RadioView_Previews: PreviewProvider {
  static var previews: some View {
    RadioView(store: Store(
      initialState: ApiState(),
      reducer: apiReducer,
      environment: ApiEnvironment()),
              model: Model.shared)
    .frame(minWidth: 1000)
  }
}
