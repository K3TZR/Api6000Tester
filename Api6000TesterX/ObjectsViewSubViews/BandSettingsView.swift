//
//  BandSettingsView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct BandSettingsView: View {
  @EnvironmentObject var model: Model
  
  var body: some View {
        
    VStack(alignment: .leading) {
      ForEach(model.bandSettings) { setting in
        HStack(spacing: 20) {
          Group {
            Text("                ")

            HStack(spacing: 5) {
              Text("Band")
              Text("\(setting.bandName)")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .frame(width: 40)
                .foregroundColor(.green)
            }
            HStack(spacing: 5) {
              Text("Rf Power")
              Text("\(setting.rfPower)")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .frame(width: 40)
                .foregroundColor(.green)
            }
            
            HStack(spacing: 5) {
              Text("Tune Power")
              Text("\(setting.tunePower)")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .frame(width: 40)
                .foregroundColor(.green)
            }
          }
          
          Group {
            HStack(spacing: 5) {
              Text("Tx1")
              Text(setting.tx1Enabled ? "Y" : "N").foregroundColor(setting.tx1Enabled  ? .green : .red)
            }
            HStack(spacing: 5) {
              Text("Tx2")
              Text(setting.tx2Enabled ? "Y" : "N").foregroundColor(setting.tx2Enabled  ? .green : .red)
            }
            HStack(spacing: 5) {
              Text("Tx3")
              Text(setting.tx3Enabled ? "Y" : "N").foregroundColor(setting.tx3Enabled  ? .green : .red)
            }
            HStack(spacing: 5) {
              Text("Acc Tx")
              Text(setting.accTxEnabled ? "Y" : "N").foregroundColor(setting.accTxEnabled  ? .green : .red)
            }
            HStack(spacing: 5) {
              Text("Acc Tx Req")
              Text(setting.accTxReqEnabled ? "Y" : "N").foregroundColor(setting.accTxReqEnabled ? .green : .red)
            }
            HStack(spacing: 5) {
              Text("Rca Tx Req")
              Text(setting.rcaTxReqEnabled ? "Y" : "N").foregroundColor(setting.rcaTxReqEnabled ? .green : .red)
            }
            HStack(spacing: 5) {
              Text("HW Alc")
              Text(setting.hwAlcEnabled ? "Y" : "N").foregroundColor(setting.hwAlcEnabled ? .green : .red)
            }
            HStack(spacing: 5) {
              Text("Inhibit")
              Text(setting.inhibit ? "Y" : "N").foregroundColor(setting.inhibit ? .green : .red)
            }
          }
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct BandSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    BandSettingsView()
      .frame(minWidth: 975)
      .padding()
  }
}
