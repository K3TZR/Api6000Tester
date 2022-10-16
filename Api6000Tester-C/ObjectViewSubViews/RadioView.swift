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
  let store: StoreOf<ApiModule>
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    VStack(alignment: .leading) {
      DetailView(store: store, viewModel: viewModel)
    }
  }
}

private struct DetailView: View {
  let store: StoreOf<ApiModule>
  @ObservedObject var viewModel: ViewModel
  
  @State var showSubView = true

  var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      if viewModel.activePacket != nil {
        
        let packet = viewModel.activePacket!
        VStack(alignment: .leading) {
          HStack(spacing: 20) {
            Group {
              HStack(spacing: 0) {
                Image(systemName: showSubView ? "chevron.down" : "chevron.right")
                  .help("          Tap to toggle details")
                  .onTapGesture(perform: { showSubView.toggle() })
                 Text(" RADIO   ").foregroundColor(.blue)
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
        if showSubView { DetailSubView(store: store, viewModel: viewModel) }
      }
    }
  }
}
          
private struct DetailSubView: View {
  let store: StoreOf<ApiModule>
  @ObservedObject var viewModel: ViewModel

  let post = String(repeating: " ", count: 7)

  var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading) {
        AtuView(atu: Atu.shared)
        GpsView(gps: Gps.shared)
        
        if let radio = viewModel.radio {
          HStack(spacing: 0) {
            Text("TNFs" + post)
            HStack(spacing: 5) {
              Text("Enabled")
              Text(radio.tnfsEnabled ? "Y" : "N").foregroundColor(radio.tnfsEnabled ? .green : .red)
            }
          }
          .padding(.leading, 40)
        }
        
        TnfView(viewModel: viewModel)
        TransmitView(transmit: Transmit.shared)
        MeterStreamView(viewModel: viewModel)
      }
    }
  }
}


// ----------------------------------------------------------------------------
// MARK: - Preview

struct RadioView_Previews: PreviewProvider {
  static var previews: some View {
    RadioView(store: Store(
      initialState: ApiModule.State(),
      reducer: ApiModule()
    ),
              viewModel: ViewModel.shared)
    .frame(minWidth: 1000)
  }
}
