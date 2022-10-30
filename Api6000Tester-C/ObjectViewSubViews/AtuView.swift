//
//  AtuView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct AtuView: View {
  @ObservedObject var atu: Atu
  
  var body: some View {
    
    HStack(spacing: 20) {
      Text("ATU").frame(width: 80, alignment: .leading)

      if atu.status != "NONE" {
        Group {
          HStack(spacing: 5) {
            Text("Enabled")
            Text(atu.enabled ? "Y" : "N").foregroundColor(atu.enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Status")
            Text(atu.status == "" ? "none" : atu.status)
              .foregroundColor(atu.status == "" ? .red : .secondary)
          }
          
          HStack(spacing: 5) {
            Text("Mem enabled")
            Text(atu.memoriesEnabled ? "Y" : "N")
              .foregroundColor(atu.memoriesEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Using Mem")
            Text(atu.usingMemory ? "Y" : "N")
              .foregroundColor(atu.usingMemory ? .green : .red)
          }
        }.frame(width: 100, alignment: .leading)
        
      } else {
        Text("NOT Installed").foregroundColor(.red)
      }
    }
    .padding(.leading, 40)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct AtuView_Previews: PreviewProvider {
  
  static var previews: some View {
    
    AtuView(atu: Atu.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}


