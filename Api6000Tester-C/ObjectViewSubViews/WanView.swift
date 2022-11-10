//
//  WanView.swift
//  Api6000Tester
//
//  Created by Douglas Adams on 8/10/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct WanView: View {
  @ObservedObject var wan: Wan
  
  var body: some View {
    
    HStack(spacing: 20) {
      Text("WAN").frame(width: 80, alignment: .leading)
      HStack(spacing: 5) {
        Text("Radio_Authenticated")
        Text(wan.radioAuthenticated ? "Y" : "N").foregroundColor(wan.radioAuthenticated ? .green : .red)
      }
      HStack(spacing: 5) {
        Text("Server_Connected")
        Text(wan.serverConnected ? "Y" : "N").foregroundColor(wan.serverConnected ? .green : .red)
      }
    }
    .padding(.leading, 40)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct WanView_Previews: PreviewProvider {
  static var previews: some View {
    WanView(wan: Wan.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
