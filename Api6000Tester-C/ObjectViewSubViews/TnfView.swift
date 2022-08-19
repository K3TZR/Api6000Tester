//
//  TnfView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct TnfView: View {
  @ObservedObject var model: Model
  
  var body: some View {
    if model.tnfs.count == 0 {
      HStack(spacing: 5) {
        Text("          TNFs")
        Text("None present").foregroundColor(.red)
      }
      
    } else {
      ForEach(model.tnfs) { tnf in
        VStack (alignment: .leading) {
          HStack(spacing: 10) {
            
            HStack(spacing: 5) {
              Text("          TNF")
              Text(String(format: "%d", tnf.id)).foregroundColor(.green)
            }
            
            HStack(spacing: 5) {
              Text("Frequency")
              Text("\(tnf.frequency)").foregroundColor(.secondary)
            }
            
            HStack(spacing: 5) {
              Text("Width")
              Text("\(tnf.width)").foregroundColor(.secondary)
            }
            
            HStack(spacing: 5) {
              Text("Depth")
              Text("\(tnf.depth)").foregroundColor(.secondary)
            }
            
            HStack(spacing: 5) {
              Text("Permanent")
              Text(tnf.permanent ? "Y" : "N").foregroundColor(tnf.permanent ? .green : .red)
            }
            
            HStack(spacing: 5) {
              Text("TNFs Enabled")
              Text(model.radio?.tnfsEnabled ?? false ? "Y" : "N").foregroundColor(model.radio?.tnfsEnabled ?? false ? .green : .red)
            }
          }
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct TnfView_Previews: PreviewProvider {
  static var previews: some View {
    TnfView(model: Model.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
