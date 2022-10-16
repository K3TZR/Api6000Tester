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
  
  let post = String(repeating: " ", count: 8)

  var body: some View {
    
    HStack(spacing: 20) {
      if atu.status != "NONE" {
        
        HStack(spacing: 5) {
          Text("ATU" + post + "Enabled")
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
        Text("ATU" + post + "NOT Installed").foregroundColor(.red)
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


