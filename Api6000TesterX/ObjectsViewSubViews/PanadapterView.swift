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
  @EnvironmentObject var model: Model
  let handle: Handle
  let showMeters: Bool
  
  var body: some View {
    ForEach(model.panadapters) { panadapter in
      if panadapter.clientHandle == handle {
        HStack(spacing: 20) {
          Text("Panadapter").frame(width: 100, alignment: .trailing)
          
          Text(panadapter.id.hex).foregroundColor(.secondary)
          
          HStack(spacing: 5) {
            Text("Center")
            Text("\(panadapter.center)").foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("Bandwidth")
            Text("\(panadapter.bandwidth)").foregroundColor(.secondary)
          }
        }
        WaterfallView(panadapterId: panadapter.id)
        SliceView(panadapterId: panadapter.id, showMeters: showMeters)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct PanadapterView_Previews: PreviewProvider {
  static var previews: some View {
    PanadapterView(
      handle: 1,
      showMeters: true
    )
    .frame(minWidth: 975)
    .padding()
  }
}
