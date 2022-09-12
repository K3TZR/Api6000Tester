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
  @ObservedObject var model: Model
  
  var body: some View {
    
    VStack(alignment: .leading) {
      HStack(spacing: 10) {
        Text("        TRANSMIT")
        Group {
          HStack(spacing: 5) {
            Text("RF_Power")
            Text("\(model.transmit.rfPower)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tune_Power")
            Text("\(model.transmit.tunePower)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Frequency")
            Text("\(model.transmit.frequency)").foregroundColor(.secondary)
          }
          HStack(spacing: 5) {
            Text("Mon_Level")
            Text("\(model.transmit.txMonitorGainSb)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Comp_Level")
            Text("\(model.transmit.companderLevel)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Mic")
            Text("\(model.transmit.micSelection)").foregroundColor(.secondary)
          }
          HStack(spacing: 5) {
            Text("Mic_Level")
            Text("\(model.transmit.micLevel)").foregroundColor(.green)
          }
        }
      }
      HStack(spacing: 10) {
        Group {
          Text("                ")
          HStack(spacing: 5) {
            Text("Proc")
            Text(model.transmit.speechProcessorEnabled ? "ON" : "OFF")
              .foregroundColor(model.transmit.speechProcessorEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Comp")
            Text(model.transmit.companderEnabled ? "ON" : "OFF")
              .foregroundColor(model.transmit.companderEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Mon")
            Text(model.transmit.txMonitorEnabled ? "ON" : "OFF")
              .foregroundColor(model.transmit.txMonitorEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Acc")
            Text(model.transmit.micAccEnabled ? "ON" : "OFF")
              .foregroundColor(model.transmit.micAccEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Dax")
            Text(model.transmit.daxEnabled ? "ON" : "OFF")
              .foregroundColor(model.transmit.daxEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Vox")
            Text(model.transmit.voxEnabled ? "ON" : "OFF")
              .foregroundColor(model.transmit.voxEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Vox_Delay")
            Text("\(model.transmit.voxDelay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Vox_Level")
            Text("\(model.transmit.voxLevel)").foregroundColor(.green)
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
    TransmitView(model: Model.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
