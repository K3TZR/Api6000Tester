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
  @ObservedObject var viewModel: ViewModel
  
  @State var showSubView = true

  var body: some View {
    VStack(alignment: .leading) {
      if viewModel.activePacket == nil {
        EmptyView()

      } else {
        VStack(alignment: .leading) {
          HStack(spacing: 0) {
            Image(systemName: showSubView ? "chevron.down" : "chevron.right")
              .help("          Tap to toggle details")
              .onTapGesture(perform: { showSubView.toggle() })
            Text(" RADIO   ").foregroundColor(viewModel.activePacket!.source == .local ? .blue : .red)
              .font(.title)
              .help("          Tap to toggle details")
              .onTapGesture(perform: { showSubView.toggle() })
            Text(viewModel.activePacket!.nickname)
              .foregroundColor(viewModel.activePacket!.source == .local ? .blue : .red)

            Line1View(packet: viewModel.activePacket!).padding(.leading, 20)
          }
          Line2View(radio: viewModel.radio!)
          if showSubView { DetailSubView(viewModel: viewModel) }
        }
      }
    }
  }
}

private struct Line1View: View {
  @ObservedObject var packet: Packet
  
  var body: some View {
    
    HStack(spacing: 20) {
      Group {
        
        HStack(spacing: 5) {
          Text("Connection")
          Text(packet.source.rawValue)
            .foregroundColor(packet.source == .local ? .blue : .red)
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
        
        HStack(spacing: 5) {
          Text("Serial")
          Text(packet.serial).foregroundColor(.secondary)
        }
      }
      .frame(alignment: .leading)
    }
  }
}

private struct Line2View: View {
  @ObservedObject var radio: Radio

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
      Text("").frame(width: 120)
      
      HStack(spacing: 5) {
        Text("Ant List")
        Text(stringArrayToString(radio.antennaList)).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Mic List")
        Text(stringArrayToString(radio.micList)).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Tnf Enabled")
        Text(radio.tnfsEnabled ? "Y" : "N").foregroundColor(radio.tnfsEnabled ? .green : .red)
      }
      
      HStack(spacing: 5) {
        Text("HW")
        Text(radio.hardwareVersion ?? "").foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Uptime")
        Text("\(radio.uptime)").foregroundColor(.secondary)
        Text("(seconds)")
      }
    }
  }
}

private struct DetailSubView: View {
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    
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


// ----------------------------------------------------------------------------
// MARK: - Preview

struct RadioView_Previews: PreviewProvider {
  static var previews: some View {
    RadioView(viewModel: ViewModel.shared)
    .frame(minWidth: 1000)
  }
}
