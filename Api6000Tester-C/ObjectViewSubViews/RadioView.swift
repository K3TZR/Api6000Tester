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
  
  @State var showSubView = true
  
  var body: some View {
    
    WithViewStore(store) { viewStore in
      if viewModel.activePacket != nil {
        
        let packet = viewModel.activePacket!
        VStack(alignment: .leading) {
          HStack(spacing: 20) {
            Group {
              
              HStack(spacing: 0) {
                Text("RADIO   ").foregroundColor(.blue)
                  .font(.title)
                  .help("          Tap to toggle details")
                  .onTapGesture(perform: { showSubView.toggle() })
                Text(packet.nickname)
                  .foregroundColor(.blue)
              }
              
              HStack(spacing: 5) {
                Text("Connection")
                Text(packet.source.rawValue)
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
        if showSubView { RadioSubView(store: store, viewModel: viewModel) }
      }
    }
  }
}

struct RadioSubView: View {
  let store: Store<ApiState, ApiAction>
  @ObservedObject var viewModel: ViewModel

  let pre = String(repeating: " ", count: 6)
  let post = String(repeating: " ", count: 5)

  var body: some View {
    
    WithViewStore(store) { viewStore in
      AtuView(atu: Atu.shared)
      GpsView(gps: Gps.shared)

      if let radio = viewModel.radio {
        HStack(spacing: 0) {
          Text(pre + "TNFs" + post)
          HStack(spacing: 5) {
            Text("Enabled")
            Text(radio.tnfsEnabled ? "Y" : "N").foregroundColor(radio.tnfsEnabled ? .green : .red)
          }
        }
      }

      TnfView(viewModel: viewModel)
      TransmitView(transmit: Transmit.shared)
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
