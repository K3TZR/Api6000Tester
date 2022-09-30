//
//  InterlockView.swift
//  Api6000TesterX
//
//  Created by Douglas Adams on 8/1/22.
//

import SwiftUI

import Api6000

struct InterlockView: View {
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    
    let interlock = viewModel.interlock
    
    VStack(alignment: .leading) {
      HStack(spacing: 20) {

        Group {
          Text("        INTERLOCK")
          HStack(spacing: 5) {
            Text("Tx_Allowed")
            Text(interlock.txAllowed ? "Y" : "N")
              .foregroundColor(interlock.txAllowed ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx_Delay")
            Text("\(interlock.txDelay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tx1")
            Text(interlock.tx1Enabled ? "Y" : "N")
              .foregroundColor(interlock.tx1Enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx1_Delay")
            Text("\(interlock.tx1Delay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tx2")
            Text(interlock.tx2Enabled ? "Y" : "N")
              .foregroundColor(interlock.tx2Enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx2_Delay")
            Text("\(interlock.tx2Delay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Tx3")
            Text(interlock.tx3Enabled ? "Y" : "N")
              .foregroundColor(interlock.tx3Enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Tx3_Delay")
            Text("\(interlock.tx3Delay)").foregroundColor(.green)
          }
        }
      }
      HStack(spacing: 20) {

        Group {
          Text("                  ")
          HStack(spacing: 5) {
            Text("Acc_Tx")
            Text(interlock.accTxEnabled ? "Y" : "N")
              .foregroundColor(interlock.accTxEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Acc_Delay")
            Text("\(interlock.accTxDelay)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Acc_Tx_Req")
            Text(interlock.accTxReqEnabled ? "Y" : "N")
              .foregroundColor(interlock.accTxReqEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Acc_Tx_Req_Polarity")
            Text(interlock.accTxReqPolarity ? "+" : "-")
              .foregroundColor(interlock.accTxReqPolarity ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Rca_Tx_Req")
            Text(interlock.rcaTxReqEnabled ? "Y" : "N")
              .foregroundColor(interlock.rcaTxReqEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Rca_Tx_Req_Polarity")
            Text(interlock.rcaTxReqPolarity ? "+" : "-")
              .foregroundColor(interlock.rcaTxReqPolarity ? .green : .red)
          }
        }
      }
    }
  }
}

struct InterlockView_Previews: PreviewProvider {
  static var previews: some View {
    InterlockView(viewModel: ViewModel.shared)
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
