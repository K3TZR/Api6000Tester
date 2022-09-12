//
//  InterlockView.swift
//  Api6000TesterX
//
//  Created by Douglas Adams on 8/1/22.
//

import SwiftUI
import Api6000

struct InterlockView: View {
  @ObservedObject var model: Model
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 20) {

        Group {
          Text("        INTERLOCK")
          HStack(spacing: 5) {
            Text("Tx_Allowed")
            Text(model.interlock.txAllowed ? "Y" : "N")
              .foregroundColor(model.interlock.txAllowed ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx_Delay")
            Text("\(model.interlock.txDelay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tx1")
            Text(model.interlock.tx1Enabled ? "Y" : "N")
              .foregroundColor(model.interlock.tx1Enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx1_Delay")
            Text("\(model.interlock.tx1Delay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tx2")
            Text(model.interlock.tx2Enabled ? "Y" : "N")
              .foregroundColor(model.interlock.tx2Enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx2_Delay")
            Text("\(model.interlock.tx2Delay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tx3")
            Text(model.interlock.tx3Enabled ? "Y" : "N")
              .foregroundColor(model.interlock.tx3Enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx3_Delay")
            Text("\(model.interlock.tx3Delay)").foregroundColor(.green)
          }
        }
      }
      HStack(spacing: 20) {

        Group {
          Text("                  ")
          HStack(spacing: 5) {
            Text("Acc_Tx")
            Text(model.interlock.accTxEnabled ? "Y" : "N")
              .foregroundColor(model.interlock.accTxEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Acc_Delay")
            Text("\(model.interlock.accTxDelay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Acc_Tx_Req")
            Text(model.interlock.accTxReqEnabled ? "Y" : "N")
              .foregroundColor(model.interlock.accTxReqEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Acc_Tx_Req_Polarity")
            Text(model.interlock.accTxReqPolarity ? "+" : "-")
              .foregroundColor(model.interlock.accTxReqPolarity ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Rca_Tx_Req")
            Text(model.interlock.rcaTxReqEnabled ? "Y" : "N")
              .foregroundColor(model.interlock.rcaTxReqEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Rca_Tx_Req_Polarity")
            Text(model.interlock.rcaTxReqPolarity ? "+" : "-")
              .foregroundColor(model.interlock.rcaTxReqPolarity ? .green : .red)
          }
        }
      }
    }
  }
}

struct InterlockView_Previews: PreviewProvider {
  static var previews: some View {
    InterlockView(model: Model.shared)
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
