//
//  TransmitView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI

import Api6000
import ApiModel

// ----------------------------------------------------------------------------
// MARK: - View

struct TransmitView: View {
  @ObservedObject var transmit: Transmit
  
  var body: some View {
    
    VStack(alignment: .leading) {
      HStack(spacing: 20) {
        Text("TRANSMIT").frame(width: 80, alignment: .leading)
        
        Group {
          HStack(spacing: 5) {
            Text("RF_Power")
            Text("\(transmit.rfPower)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tune_Power")
            Text("\(transmit.tunePower)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Frequency")
            Text("\(transmit.frequency)").foregroundColor(.secondary)
          }
          HStack(spacing: 5) {
            Text("Mon_Level")
            Text("\(transmit.ssbMonitorGain)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Comp_Level")
            Text("\(transmit.companderLevel)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Mic")
            Text("\(transmit.micSelection)").foregroundColor(.secondary)
          }
          HStack(spacing: 5) {
            Text("Mic_Level")
            Text("\(transmit.micLevel)").foregroundColor(.green)
          }
        }.frame(width: 100, alignment: .leading)
      }
      
      

      HStack(spacing: 20){
        Text("").frame(width: 80, alignment: .leading)

        Group {
          HStack(spacing: 5) {
            Text("Proc")
            Text(transmit.speechProcessorEnabled ? "ON" : "OFF")
              .foregroundColor(transmit.speechProcessorEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Comp")
            Text(transmit.companderEnabled ? "ON" : "OFF")
              .foregroundColor(transmit.companderEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Mon")
            Text(transmit.txMonitorEnabled ? "ON" : "OFF")
              .foregroundColor(transmit.txMonitorEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Acc")
            Text(transmit.micAccEnabled ? "ON" : "OFF")
              .foregroundColor(transmit.micAccEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Dax")
            Text(transmit.daxEnabled ? "ON" : "OFF")
              .foregroundColor(transmit.daxEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Vox")
            Text(transmit.voxEnabled ? "ON" : "OFF")
              .foregroundColor(transmit.voxEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Vox_Delay")
            Text("\(transmit.voxDelay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Vox_Level")
            Text("\(transmit.voxLevel)").foregroundColor(.green)
          }
        }
        .frame(width: 100, alignment: .leading)
      }
    }
    .padding(.leading, 40)
  }
}
//      }
//        Group {
//          Text("                ")
//          HStack(spacing: 5) {
//            Text("Proc")
//          }
//        }
//      }
//    }
//  }
//}


// ----------------------------------------------------------------------------
// MARK: - Preview

struct TransmitView_Previews: PreviewProvider {
  static var previews: some View {
    TransmitView(transmit: Transmit.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
