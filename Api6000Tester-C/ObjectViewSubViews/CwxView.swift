//
//  CwxView.swift
//  Api6000Tester
//
//  Created by Douglas Adams on 8/10/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct CwxView: View {
  @ObservedObject var model: Model
  
  var body: some View {
    
    let cwx = model.cwx
    HStack(spacing: 20) {
      Text("          CWX")
      
      HStack(spacing: 5) {
        Text("Breakin_Delay")
        Text("\(cwx.breakInDelay)").foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("QSK_Enabled")
        Text(cwx.qskEnabled ? "Y" : "N").foregroundColor(cwx.qskEnabled ? .green : .red)
      }
      
      HStack(spacing: 5) {
        Text("WPM")
        Text("\(cwx.wpm)").foregroundColor(.secondary)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct CwxView_Previews: PreviewProvider {
  static var previews: some View {
    CwxView(model: Model.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
