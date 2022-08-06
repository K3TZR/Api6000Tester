//
//  TransmitView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct TransmitView: View {
  @ObservedObject var api6000: Model
  
  var body: some View {
    
    VStack(alignment: .leading) {
      HStack(spacing: 10) {
        Text("         TRANSMIT -> ")
        Group {
          HStack(spacing: 5) {
            Text("RF Power")
            Text("\(api6000.transmit.rfPower)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tune Power")
            Text("\(api6000.transmit.tunePower)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Frequency")
            Text("\(api6000.transmit.frequency)").foregroundColor(.secondary)
          }
          HStack(spacing: 5) {
            Text("Mon Level")
            Text("\(api6000.transmit.txMonitorGainSb)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Comp Level")
            Text("\(api6000.transmit.companderLevel)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Mic")
            Text("\(api6000.transmit.micSelection)").foregroundColor(.secondary)
          }
          HStack(spacing: 5) {
            Text("Mic Level")
            Text("\(api6000.transmit.micLevel)").foregroundColor(.green)
          }
        }
      }
      HStack(spacing: 10) {
        Group {
          Text("                     ")
          HStack(spacing: 5) {
            Text("Proc")
            Text(api6000.transmit.speechProcessorEnabled ? "ON" : "OFF")
              .foregroundColor(api6000.transmit.speechProcessorEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Comp")
            Text(api6000.transmit.companderEnabled ? "ON" : "OFF")
              .foregroundColor(api6000.transmit.companderEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Mon")
            Text(api6000.transmit.txMonitorEnabled ? "ON" : "OFF")
              .foregroundColor(api6000.transmit.txMonitorEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Acc")
            Text(api6000.transmit.micAccEnabled ? "ON" : "OFF")
              .foregroundColor(api6000.transmit.micAccEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Dax")
            Text(api6000.transmit.daxEnabled ? "ON" : "OFF")
              .foregroundColor(api6000.transmit.daxEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Vox")
            Text(api6000.transmit.voxEnabled ? "ON" : "OFF")
              .foregroundColor(api6000.transmit.voxEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Vox Delay")
            Text("\(api6000.transmit.voxDelay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Vox Level")
            Text("\(api6000.transmit.voxLevel)").foregroundColor(.green)
          }
        }
      }
    }
  }
}


// ----------------------------------------------------------------------------
// MARK: - Preview

struct TransmitView_Previews: PreviewProvider {
  static var previews: some View {
    TransmitView(api6000: Model.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
