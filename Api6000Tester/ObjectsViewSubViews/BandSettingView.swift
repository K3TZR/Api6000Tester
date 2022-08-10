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

struct BandSettingView: View {
  @ObservedObject var api6000: Model
  
  var body: some View {
    
    if api6000.bandSettings.count == 0 {
      HStack(spacing: 5) {
        Text("         BANDSETTINGs")
        Text("None present").foregroundColor(.red)
      }
      
    } else {
      ForEach(api6000.bandSettings) { setting in
        VStack(alignment: .leading) {
          HStack(spacing: 20) {
            Group {
              HStack(spacing: 5) {
                Text("         BAND")
                Text("\(setting.bandName)")
                  .frame(maxWidth: .infinity, alignment: .trailing)
                  .frame(width: 40)
                  .foregroundColor(.green)
              }
              HStack(spacing: 5) {
                Text("Rf_Power")
                Text("\(setting.rfPower)")
                  .frame(maxWidth: .infinity, alignment: .trailing)
                  .frame(width: 40)
                  .foregroundColor(.green)
              }
              
              HStack(spacing: 5) {
                Text("Tune_Power")
                Text("\(setting.tunePower)")
                  .frame(maxWidth: .infinity, alignment: .trailing)
                  .frame(width: 40)
                  .foregroundColor(.green)
              }
            }
            HStack(spacing: 20) {
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
                  Text("Acc_Tx")
                  Text(setting.accTxEnabled ? "Y" : "N").foregroundColor(setting.accTxEnabled  ? .green : .red)
                }
                HStack(spacing: 5) {
                  Text("Acc_Tx_Req")
                  Text(setting.accTxReqEnabled ? "Y" : "N").foregroundColor(setting.accTxReqEnabled ? .green : .red)
                }
                HStack(spacing: 5) {
                  Text("Rca_Tx_Req")
                  Text(setting.rcaTxReqEnabled ? "Y" : "N").foregroundColor(setting.rcaTxReqEnabled ? .green : .red)
                }
                HStack(spacing: 5) {
                  Text("HW_Alc")
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
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct BandSettingView_Previews: PreviewProvider {
  static var previews: some View {
    BandSettingView(api6000: Model.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
