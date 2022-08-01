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
    if model.radio!.atuPresent {
      let atu = model.atu
      HStack(spacing: 20) {
        Text("ATU        ->")
        
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
          Text("Memories enabled")
          Text(atu.memoriesEnabled ? "Y" : "N")
            .foregroundColor(atu.memoriesEnabled ? .green : .red)
        }
        HStack(spacing: 5) {
          Text("Using memories")
          Text(atu.usingMemory ? "Y" : "N")
            .foregroundColor(atu.usingMemory ? .green : .red)
        }
      }
      .frame(minWidth: 1000, maxWidth: .infinity, alignment: .leading)

    } else {
      HStack(spacing: 20) {
        Text("ATU        ->")
        Text("NOT INSTALLED").foregroundColor(.red)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct AtuView_Previews: PreviewProvider {
  
  static var previews: some View {
    
    AtuView(model: Model.shared)
      .frame(minWidth: 975)
      .padding()
  }
}


