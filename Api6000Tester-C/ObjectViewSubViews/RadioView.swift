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
                Text(" RADIO   ").foregroundColor(viewModel.activePacket!.source == .local ? .blue : .red)
                  .font(.title)
                  .help("          Tap to toggle details")
                  .onTapGesture(perform: { showSubView.toggle() })
                Text(packet.nickname)
                  .foregroundColor(viewModel.activePacket!.source == .local ? .blue : .red)
              }
              
              HStack(spacing: 5) {
                Text("Connection")
                Text(packet.source.rawValue)
                  .foregroundColor(viewModel.activePacket?.source == .local ? .blue : .red)
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
                Text("HW")
                Text(viewModel.radio?.hardwareVersion ?? "Unknown").foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("Model")
                Text(packet.model).foregroundColor(.secondary)
              }
              
              HStack(spacing: 5) {
                Text("Serial")
                Text(packet.serial).foregroundColor(.secondary)
              }
            }
            .frame(alignment: .leading)
          }
          Line2View(viewModel: viewModel)
        }
      }
      if showSubView { DetailSubView(store: store, viewModel: viewModel) }
    }
  }
}

private struct Line2View: View {
  @ObservedObject var viewModel: ViewModel

  func stringArrayToString( _ list: [String]?) -> String {
    
    guard list != nil else { return "Unknown"}
    let str = list!.reduce("") {$0 + $1 + ", "}
    return String(str.dropLast(2))
  }
  
  func uint32ArrayToString( _ list: [UInt32]) -> String {
    let str = list.reduce("") {String($0) + String($1) + ", "}
    return String(str.dropLast(2))
  }
  
  var body: some View {
    HStack(spacing: 20) {
      Text("").frame(width: 165)
      
      HStack(spacing: 5) {
        Text("Ant List")
        Text(stringArrayToString(viewModel.radio?.antennaList)).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Mic List")
        Text(stringArrayToString(viewModel.radio?.micList)).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Tnf Enabled")
        Text(viewModel.radio?.tnfsEnabled ?? false ? "Y" : "N").foregroundColor(viewModel.radio?.tnfsEnabled ?? false ? .green : .red)
      }
    }
  }
}

private struct DetailSubView: View {
  let store: StoreOf<ApiModule>
  @ObservedObject var viewModel: ViewModel

  var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Divider().background(viewModel.activePacket?.source == .local ? .blue : .red)
      VStack(alignment: .leading) {
        AtuView(atu: Atu.shared)
        GpsView(gps: Gps.shared)
        MeterStreamView(viewModel: viewModel)
        TransmitView(transmit: Transmit.shared)
        TnfView(viewModel: viewModel)
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
