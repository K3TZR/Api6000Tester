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
  @ObservedObject var api6000: Model
  
  var body: some View {
    if api6000.tnfs.count == 0 {
      HStack(spacing: 5) {
        Text("         TNFs      ")
        Text("None present").foregroundColor(.red)
      }
      
    } else {
      ForEach(api6000.tnfs) { tnf in
        VStack (alignment: .leading) {
          HStack(spacing: 10) {
            
            HStack(spacing: 5) {
              Text("          TNF       ")
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
              Text(api6000.radio!.tnfsEnabled ? "Y" : "N").foregroundColor(api6000.radio!.tnfsEnabled ? .green : .red)
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
    TnfView(api6000: Model.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
