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
    ForEach(model.panadapters) { panadapter in
      if panadapter.clientHandle == handle {
        HStack(spacing: 20) {
          Text("Panadapter").frame(width: 100, alignment: .trailing)
          Text(panadapter.id.hex)
          Text("Center \(panadapter.center)")
          Text("Bandwidth \(panadapter.bandwidth)")
        }
        WaterfallView(model: model, panadapterId: panadapter.id)
        SliceView(model: model, panadapterId: panadapter.id, showMeters: showMeters)
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
    .frame(minWidth: 975)
    .padding()
  }
}
