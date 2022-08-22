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
  @ObservedObject var model: Model
  
  var body: some View {
    if let radio = model.radio {
      HStack(spacing: 10) {
        Text("          ATU  ")
        if radio.atuPresent {
          let atu = model.atu
          
          HStack(spacing: 5) {
            Text("Enabled")
            Text(atu.enabled ? "Y" : "N")
              .foregroundColor(atu.enabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Status")
            Text(atu.status == "" ? "none" : atu.status)
              .foregroundColor(atu.status == "" ? .red : .secondary)
          }
          
          HStack(spacing: 5) {
            Text("Memories_enabled")
            Text(atu.memoriesEnabled ? "Y" : "N")
              .foregroundColor(atu.memoriesEnabled ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Using_memories")
            Text(atu.usingMemory ? "Y" : "N")
              .foregroundColor(atu.usingMemory ? .green : .red)
          }
        } else {
          Text("NOT Installed").foregroundColor(.red)
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct AtuView_Previews: PreviewProvider {
  
  static var previews: some View {
    
    AtuView(model: Model.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}


