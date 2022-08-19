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
  
  var body: some View {
    
    WithViewStore(store) { viewStore in
//      if viewStore.model.activePacketId != nil {
        VStack(alignment: .leading) {
          HStack(spacing: 10) {
            Group {
              
              HStack(spacing: 0) {
                Text("RADIO     ").foregroundColor(.blue)
//                Text(api6000.packets[id: api6000.activePacketId!]!.source.rawValue)
//                  .foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("Name")
//                Text(api6000.packets[id: api6000.activePacketId!]!.nickname)
//                  .foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("Ip")
//                Text(api6000.packets[id: api6000.activePacketId!]!.publicIp).foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("FW")
//                Text(api6000.packets[id: api6000.activePacketId!]!.version).foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("Model")
//                Text(api6000.packets[id: api6000.activePacketId!]!.model).foregroundColor(.secondary)
              }
            }
            Group {
              HStack(spacing: 5) {
                Text("Serial")
//                Text(api6000.packets[id: api6000.activePacketId!]!.serial).foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("Stations")
//                Text(api6000.packets[id: api6000.activePacketId!]!.guiClientStations).foregroundColor(.secondary)
              }.frame(width: 150, alignment: .leading)
              
              HStack(spacing: 5) {
                Text("Atu")
//                Text(api6000.radio!.atuPresent ? "Y" : "N").foregroundColor(api6000.radio!.atuPresent ? .green : .red)
              }
              
              HStack(spacing: 5) {
                Text("Gps")
//                Text(api6000.radio!.gpsPresent ? "Y" : "N").foregroundColor(api6000.radio!.gpsPresent ? .green : .red)
              }
              
              HStack(spacing: 5) {
                Text("Scu")
//                Text("\(api6000.radio!.numberOfScus)").foregroundColor(.green)
              }
            }
          }
        }
        //        AtuView(api6000: api6000)
        //        GpsView(api6000: api6000)
        //        TnfView(api6000: api6000)
      }
//    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct RadioView_Previews: PreviewProvider {
  static var previews: some View {
    RadioView(store: Store(
      initialState: ApiState(),
      reducer: apiReducer,
      environment: ApiEnvironment())
    )
    .frame(minWidth: 1000)
  }
}
