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
  @ObservedObject var api6000: Model
  let panadapterId: PanadapterId
  let handle: Handle
  let showMeters: Bool
  
  func valueColor(_ value: Float, _ low: Float, _ high: Float) -> Color {
    if value > high { return .red }
    if value < low { return .yellow }
    return .green
  }
  
  var body: some View {
    
    if api6000.slices.count == 0 {
      HStack(spacing: 5) {
        Text("         SLICEs")
        Text("None present").foregroundColor(.red)
      }
    
    } else {
      ForEach(api6000.slices) { slice in
        if slice.panadapterId == panadapterId {
          VStack {
            HStack(spacing: 20) {
              HStack(spacing: 5) {
                Text("         SLICE   ")
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
                Text("Filter_Low")
                Text("\(slice.filterLow)").foregroundColor(.secondary)
              }
              HStack(spacing: 5) {
                Text("Filter_High")
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
                Text("DAX_channel")
                Text("\(slice.daxChannel)").foregroundColor(.green)
              }
              HStack(spacing: 5) {
                Text("DAX_clients")
                Text("\(slice.daxClients)").foregroundColor(.green)
              }
            }
            if showMeters { MeterView(api6000: api6000, sliceId: slice.id, sliceClientHandle: slice.clientHandle, handle: handle) }
          }
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct SliceView_Previews: PreviewProvider {
  static var previews: some View {
    SliceView(
      api6000: Model.shared,
      panadapterId: 1,
      handle: 1,
      showMeters: true
    )
    .frame(minWidth: 1000)
    .padding()
  }
}
