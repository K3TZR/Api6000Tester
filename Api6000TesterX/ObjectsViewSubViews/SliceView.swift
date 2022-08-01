//
//  SliceView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/24/22.
//

import SwiftUI

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct SliceView: View {
  @EnvironmentObject var model: Model
  let panadapterId: PanadapterId
  let showMeters: Bool
  
  func valueColor(_ value: Float, _ low: Float, _ high: Float) -> Color {
    if value > high { return .red }
    if value < low { return .yellow }
    return .green
  }
  
  var body: some View {
    ForEach(model.slices) { slice in
      if slice.panadapterId == panadapterId {
        HStack(spacing: 20) {
          HStack(spacing: 5) {
            Text("Slice").frame(width: 100, alignment: .trailing)
            Text(String(format: "% 3d", slice.id)).foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("Frequency")
            Text("\(slice.frequency)").foregroundColor(.secondary)
          }
          HStack(spacing: 5) {
            Text("Mode")
            Text("\(slice.mode)").foregroundColor(.secondary)
          }
          HStack(spacing: 5) {
            Text("FilterLow")
            Text("\(slice.filterLow)").foregroundColor(.secondary)
          }
          HStack(spacing: 5) {
            Text("FilterHigh")
            Text("\(slice.filterHigh)").foregroundColor(.secondary)
          }
          HStack(spacing: 5) {
            Text("Active")
            Text(slice.active ? "Y" : "N").foregroundColor(slice.active ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("Locked")
            Text(slice.locked ? "Y" : "N").foregroundColor(slice.locked ? .green : .red)
          }
          HStack(spacing: 5) {
            Text("DAX channel")
            Text("\(slice.daxChannel)").foregroundColor(.green)
          }
          HStack(spacing: 5) {
            Text("DAX clients")
            Text("\(slice.daxClients)").foregroundColor(.green)
          }
        }
        if showMeters { MeterView(sliceId: slice.id) }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct SliceView_Previews: PreviewProvider {
  static var previews: some View {
    SliceView(
      panadapterId: 1,
      showMeters: true
    )
    .frame(minWidth: 975)
    .padding()
  }
}
