//
//  RadioView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import ComposableArchitecture
import SwiftUI

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct RadioView: View {
  let store: Store<ApiState, ApiAction>
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    
    WithViewStore(store) { viewStore in
      if viewModel.activePacket != nil {
        
        let packet = viewModel.activePacket!
        VStack(alignment: .leading) {
          HStack(spacing: 10) {
            Group {
              
              HStack(spacing: 0) {
                Text("RADIO   ").foregroundColor(.blue)
                Text(packet.source.rawValue)
                  .foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("Name")
                Text(packet.nickname)
                  .foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("Ip")
                Text(packet.publicIp).foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("FW")
                Text(packet.version).foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("Model")
                Text(packet.model).foregroundColor(.secondary)
              }
            }
            Group {
              HStack(spacing: 5) {
                Text("Serial")
                Text(packet.serial).foregroundColor(.secondary)
              }

              HStack(spacing: 5) {
                Text("Stations")
                Text(packet.guiClientStations).foregroundColor(.secondary)
              }.frame(width: 150, alignment: .leading)
            }
          }
        }
        RadioSubView(store: store, viewModel: viewModel)
      }
    }
  }
}

struct RadioSubView: View {
  let store: Store<ApiState, ApiAction>
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    
    WithViewStore(store) { viewStore in
      AtuView(viewModel: viewModel)
      GpsView(viewModel: viewModel)

      if let radio = viewModel.radio {
        HStack(spacing: 10) {
          Text("        TNFs ")
          HStack(spacing: 5) {
            Text("Enabled")
            Text(radio.tnfsEnabled ? "Y" : "N").foregroundColor(radio.tnfsEnabled ? .green : .red)
          }
        }
      }

      TnfView(viewModel: viewModel)
      MeterStreamView(viewModel: viewModel)
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
      environment: ApiEnvironment()
    ),
              viewModel: ViewModel.shared)
    .frame(minWidth: 1000)
  }
}
