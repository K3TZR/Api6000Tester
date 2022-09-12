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
  @ObservedObject var model: Model
  let handle: Handle
  let showMeters: Bool
  
  var body: some View {
    
    if model.panadapters.count == 0 {
      HStack(spacing: 5) {
        Text("        PANADAPTERs")
        Text("None present").foregroundColor(.red)
      }
      
    } else {
      
      VStack(alignment: .leading) {
        ForEach(model.panadapters) { panadapter in
          if panadapter.clientHandle == handle {
            HStack(spacing: 20) {
              HStack(spacing: 5) {
                Text("        PANADAPTER")
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
            WaterfallView(model: model, panadapterId: panadapter.id)
            SliceView(model: model, panadapterId: panadapter.id, handle: handle, showMeters: showMeters)
          }
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
      model: Model.shared,
      handle: 1,
      showMeters: true
    )
    .frame(minWidth: 1000)
    .padding()
  }
}
