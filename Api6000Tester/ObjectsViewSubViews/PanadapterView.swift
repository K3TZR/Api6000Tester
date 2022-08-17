//
//  PanadapterView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/24/22.
//

import SwiftUI

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct PanadapterView: View {
  @ObservedObject var api6000: Model
  let handle: Handle
  let showMeters: Bool
  
  var body: some View {
    
    if api6000.panadapters.count == 0 {
      HStack(spacing: 5) {
        Text("          PANADAPTERs")
        Text("None present").foregroundColor(.red)
      }
      
    } else {
      ForEach(api6000.panadapters) { panadapter in
        if panadapter.clientHandle == handle {
          HStack(spacing: 20) {
            HStack(spacing: 5) {
              Text("          PANADAPTER")
              Text(panadapter.id.hex).foregroundColor(.secondary)
            }
            
            HStack(spacing: 5) {
              Text("Streaming")
              Text(panadapter.isStreaming ? "Y" : "N").foregroundColor(panadapter.isStreaming ? .green : .red)
            }

            HStack(spacing: 5) {
              Text("Center")
              Text("\(panadapter.center)").foregroundColor(.secondary)
            }
            
            HStack(spacing: 5) {
              Text("Bandwidth")
              Text("\(panadapter.bandwidth)").foregroundColor(.secondary)
            }
          }
          WaterfallView(api6000: api6000, panadapterId: panadapter.id)
          SliceView(api6000: api6000, panadapterId: panadapter.id, handle: handle, showMeters: showMeters)
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct PanadapterView_Previews: PreviewProvider {
  static var previews: some View {
    PanadapterView(
      api6000: Model.shared,
      handle: 1,
      showMeters: true
    )
    .frame(minWidth: 1000)
    .padding()
  }
}
