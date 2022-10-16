//
//  InterlockView.swift
//  Api6000TesterX
//
//  Created by Douglas Adams on 8/1/22.
//

import SwiftUI

import Api6000

struct InterlockView: View {
  @ObservedObject var interlock: Interlock
  
  var body: some View {
    VStack(alignment: .leading) {
      HeadingView()
      DetailView(interlock: interlock)
    }
    .padding(.leading, 40)
  }
}
//    VStack(alignment: .leading) {
//      HStack(spacing: 20) {
//
//        Group {
//          Text("INTERLOCK")
//          HStack(spacing: 5) {
//            Text("Tx_Allowed")
//            Text(interlock.txAllowed ? "Y" : "N")
//              .foregroundColor(interlock.txAllowed ? .green : .red)
//          }
//          HStack(spacing: 5) {
//            Text("Tx_Delay")
//            Text("\(interlock.txDelay)").foregroundColor(.green)
//          }
//          HStack(spacing: 5) {
//            Text("Tx1")
//            Text(interlock.tx1Enabled ? "Y" : "N")
//              .foregroundColor(interlock.tx1Enabled ? .green : .red)
//          }
//          HStack(spacing: 5) {
//            Text("Tx1_Delay")
//            Text("\(interlock.tx1Delay)").foregroundColor(.green)
//          }
//          HStack(spacing: 5) {
//            Text("Tx2")
//            Text(interlock.tx2Enabled ? "Y" : "N")
//              .foregroundColor(interlock.tx2Enabled ? .green : .red)
//          }
//          HStack(spacing: 5) {
//            Text("Tx2_Delay")
//            Text("\(interlock.tx2Delay)").foregroundColor(.green)
//          }
//          HStack(spacing: 5) {
//            Text("Tx3")
//            Text(interlock.tx3Enabled ? "Y" : "N")
//              .foregroundColor(interlock.tx3Enabled ? .green : .red)
//          }
//          HStack(spacing: 5) {
//            Text("Tx3_Delay")
//            Text("\(interlock.tx3Delay)").foregroundColor(.green)
//          }
//        }
//      }
//      .padding(.leading, 40)
//      HStack(spacing: 20) {
//
//      }
//    }
//  }
//}

private struct HeadingView: View {
  
  var body: some View {
    HStack(spacing: 10) {
      Text("INTERLOCK").frame(width: 100, alignment: .leading)
      Group {
        Text("Tx / Delay")
        Text("Tx1 / Delay")
        Text("Tx2 / Delay")
        Text("Tx3 / Delay")
        Text("Acc / Delay")
        Text("Acc Req / Pol")
        Text("Rca Req / Pol")
      }.frame(width: 110)
    }
    Text("")
  }
}

private struct DetailView: View {
  @ObservedObject var interlock: Interlock
  
  var body: some View {
    HStack(spacing: 10) {
      
      Group {
        HStack(spacing: 5) {
          Text(interlock.txAllowed ? "Y" : "N").foregroundColor(interlock.txAllowed ? .green : .red)
          Text("/")
          Text(String(format: "%#4d", interlock.txDelay)).foregroundColor(.green)
        }
        HStack(spacing: 5) {
          Text(interlock.tx1Enabled ? "Y" : "N").foregroundColor(interlock.tx1Enabled ? .green : .red)
          Text("/")
          Text(String(format: "%#4d", interlock.tx1Delay)).foregroundColor(.green)
        }
        HStack(spacing: 5) {
          Text(interlock.tx2Enabled ? "Y" : "N").foregroundColor(interlock.tx2Enabled ? .green : .red)
          Text("/")
          Text(String(format: "%#4d", interlock.tx2Delay)).foregroundColor(.green)
        }
        HStack(spacing: 5) {
          Text(interlock.tx3Enabled ? "Y" : "N").foregroundColor(interlock.tx3Enabled ? .green : .red)
          Text("/")
          Text(String(format: "%#4d", interlock.tx3Delay)).foregroundColor(.green)
        }
        HStack(spacing: 5) {
          Text(interlock.accTxEnabled ? "Y" : "N").foregroundColor(interlock.accTxEnabled ? .green : .red)
          Text("/")
          Text(String(format: "%#4d", interlock.accTxDelay)).foregroundColor(.green)
        }
        HStack(spacing: 5) {
          Text(interlock.accTxReqEnabled ? "Y" : "N").foregroundColor(interlock.accTxReqEnabled ? .green : .red)
          Text("/")
          Text(interlock.accTxReqPolarity ? "+" : "-").foregroundColor(interlock.accTxReqPolarity ? .green : .red)
        }
        HStack(spacing: 5) {
          Text(interlock.rcaTxReqEnabled ? "Y" : "N").foregroundColor(interlock.rcaTxReqEnabled ? .green : .red)
          Text("/")
          Text(interlock.rcaTxReqPolarity ? "+" : "-").foregroundColor(interlock.rcaTxReqPolarity ? .green : .red)
        }
      }
      .frame(width: 110)
    }
    .padding(.leading, 100)
  }
}

struct InterlockView_Previews: PreviewProvider {
  static var previews: some View {
    InterlockView(interlock: Interlock.shared)
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
