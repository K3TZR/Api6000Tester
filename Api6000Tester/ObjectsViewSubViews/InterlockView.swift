//
//  InterlockView.swift
//  Api6000TesterX
//
//  Created by Douglas Adams on 8/1/22.
//

import SwiftUI
import Api6000

struct InterlockView: View {
  @ObservedObject var api6000: Model
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 20) {

        Group {
          Text("         INTERLOCK")
          HStack(spacing: 5) {
            Text("Tx_Allowed")
            Text(api6000.interlock.txAllowed ? "Y" : "N")
              .foregroundColor(api6000.interlock.txAllowed ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx_Delay")
            Text("\(api6000.interlock.txDelay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tx1")
            Text(api6000.interlock.tx1Enabled ? "Y" : "N")
              .foregroundColor(api6000.interlock.tx1Enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx1_Delay")
            Text("\(api6000.interlock.tx1Delay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tx2")
            Text(api6000.interlock.tx2Enabled ? "Y" : "N")
              .foregroundColor(api6000.interlock.tx2Enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx2_Delay")
            Text("\(api6000.interlock.tx2Delay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tx3")
            Text(api6000.interlock.tx3Enabled ? "Y" : "N")
              .foregroundColor(api6000.interlock.tx3Enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx3_Delay")
            Text("\(api6000.interlock.tx3Delay)").foregroundColor(.green)
          }
        }
      }
      HStack(spacing: 20) {

        Group {
          Text("                  ")
          HStack(spacing: 5) {
            Text("Acc_Tx")
            Text(api6000.interlock.accTxEnabled ? "Y" : "N")
              .foregroundColor(api6000.interlock.accTxEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Acc_Delay")
            Text("\(api6000.interlock.accTxDelay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Acc_Tx_Req")
            Text(api6000.interlock.accTxReqEnabled ? "Y" : "N")
              .foregroundColor(api6000.interlock.accTxReqEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Acc_Tx_Req_Polarity")
            Text(api6000.interlock.accTxReqPolarity ? "+" : "-")
              .foregroundColor(api6000.interlock.accTxReqPolarity ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Rca_Tx_Req")
            Text(api6000.interlock.rcaTxReqEnabled ? "Y" : "N")
              .foregroundColor(api6000.interlock.rcaTxReqEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Rca_Tx_Req_Polarity")
            Text(api6000.interlock.rcaTxReqPolarity ? "+" : "-")
              .foregroundColor(api6000.interlock.rcaTxReqPolarity ? .green : .red)
          }
        }
      }
    }
  }
}

struct InterlockView_Previews: PreviewProvider {
  static var previews: some View {
    InterlockView(api6000: Model.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}

// amplifier = ""
// reason = ""
// source = ""
// state = ""
// timeout = 0
// txClientHandle: Handle = 0
