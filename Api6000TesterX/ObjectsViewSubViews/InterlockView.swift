//
//  InterlockView.swift
//  Api6000TesterX
//
//  Created by Douglas Adams on 8/1/22.
//

import SwiftUI
import Api6000

struct InterlockView: View {
  @EnvironmentObject var model: Model
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 20) {
        Text("                ")
        
        Group {
          HStack(spacing: 5) {
            Text("Tx")
            Text(model.interlock.txAllowed ? "Y" : "N")
              .foregroundColor(model.interlock.txAllowed ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx Delay")
            Text("\(model.interlock.txDelay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tx1")
            Text(model.interlock.tx1Enabled ? "Y" : "N")
              .foregroundColor(model.interlock.tx1Enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx1 Delay")
            Text("\(model.interlock.tx1Delay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tx2")
            Text(model.interlock.tx2Enabled ? "Y" : "N")
              .foregroundColor(model.interlock.tx2Enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx2 Delay")
            Text("\(model.interlock.tx2Delay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tx3")
            Text(model.interlock.tx3Enabled ? "Y" : "N")
              .foregroundColor(model.interlock.tx3Enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx3 Delay")
            Text("\(model.interlock.tx3Delay)").foregroundColor(.green)
          }
        }
      }
      HStack(spacing: 20) {
        Text("                ")
        
        Group {
          HStack(spacing: 5) {
            Text("Acc Tx")
            Text(model.interlock.accTxEnabled ? "Y" : "N")
              .foregroundColor(model.interlock.accTxEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Acc Delay")
            Text("\(model.interlock.accTxDelay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Acc Tx Req")
            Text(model.interlock.accTxReqEnabled ? "Y" : "N")
              .foregroundColor(model.interlock.accTxReqEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Acc Tx Req Polarity")
            Text(model.interlock.accTxReqPolarity ? "+" : "-")
              .foregroundColor(model.interlock.accTxReqPolarity ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Rca Tx Req")
            Text(model.interlock.rcaTxReqEnabled ? "Y" : "N")
              .foregroundColor(model.interlock.rcaTxReqEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Rca Tx Req Polarity")
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
    InterlockView()
  }
}

// amplifier = ""
// reason = ""
// source = ""
// state = ""
// timeout = 0
// txClientHandle: Handle = 0
