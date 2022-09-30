//
//  UsbCableView.swift
//  Api6000Tester
//
//  Created by Douglas Adams on 8/10/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct UsbCableView: View {
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    if viewModel.usbCables.count == 0 {
      HStack(spacing: 5) {
        Text("        USBCABLEs")
        Text("None present").foregroundColor(.red)
      }
      
    } else {
      ForEach(viewModel.usbCables) { cable in
        VStack (alignment: .leading) {
          DetailView1(cable: cable)
          DetailView2(cable: cable)
        }
      }
    }
  }
}

private struct DetailView1: View {
  @ObservedObject var cable: UsbCable
  
  var body: some View {
    HStack(spacing: 20) {
      HStack(spacing: 5) {
        Text("        USBCABLE")
        Text(cable.id).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Id")
        Text(cable.id ).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Name")
        Text(cable.name).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Source")
        Text(cable.source).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Enabled")
        Text(cable.enable ? "Y" : "N").foregroundColor(cable.enable ? .green : .red)
      }
      
      HStack(spacing: 5) {
        Text("Band")
        Text(cable.band).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Polarity")
        Text(cable.polarity).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Flow_Control")
        Text(cable.flowControl).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Data_Bits")
        Text(String(format: "%2d", cable.dataBits)).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Stop_Bits")
        Text(String(format: "%2d", cable.stopBits)).foregroundColor(.secondary)
      }
    }
  }
}

private struct DetailView2: View {
  @ObservedObject var cable: UsbCable
  
  var body: some View {
    
    HStack(spacing: 10) {
      HStack(spacing: 5) {
        Text("Parity")
        Text(cable.parity).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Speed")
        Text("\(cable.speed)").foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Source_Rx_Ant")
        Text(cable.sourceRxAnt).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Source_Tx_Ant")
        Text(cable.sourceTxAnt).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Source_Slice")
        Text(String(format: "%2d", cable.sourceSlice)).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Preamp")
        Text(cable.preamp).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("UsbLog")
        Text(cable.usbLog ? "Y" : "N").foregroundColor(cable.usbLog ? .green : .red)
      }
      
      HStack(spacing: 5) {
        Text("Auto_Report")
        Text(cable.autoReport ? "Y" : "N").foregroundColor(cable.autoReport ? .green : .red)
      }
    }
  }
}


// ----------------------------------------------------------------------------
// MARK: - Preview

struct UsbCableView_Previews: PreviewProvider {
  static var previews: some View {
    UsbCableView(viewModel: ViewModel.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
