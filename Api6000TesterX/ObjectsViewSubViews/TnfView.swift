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
    ForEach(Array(model.tnfs)) { tnf in
      HStack(spacing: 20) {
        Text("Tnf").frame(width: 100, alignment: .trailing)
        Text(String(format: "%d", tnf.id))
        Text("Frequency \(tnf.frequency)")
        Text("Width \(tnf.width)")
        Text("Depth \(tnf.depth)")
        Text("Permanent \(tnf.permanent ? "Y" : "N")")
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct TnfView_Previews: PreviewProvider {
  static var previews: some View {
    TnfView(model: Model.shared)
    .frame(minWidth: 975)
    .padding()
  }
}
