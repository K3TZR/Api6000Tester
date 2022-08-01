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
  @EnvironmentObject var model: Model
  
  var body: some View {
    ForEach(Array(model.tnfs)) { tnf in
      HStack(spacing: 20) {
        Text("Tnf").frame(width: 100, alignment: .trailing)
        Text(String(format: "%d", tnf.id)).foregroundColor(.green)
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
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct TnfView_Previews: PreviewProvider {
  static var previews: some View {
    TnfView()
    .frame(minWidth: 975)
    .padding()
  }
}
