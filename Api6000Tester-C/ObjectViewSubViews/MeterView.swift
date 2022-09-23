//
//  MeterView.swift
//  Api6000Components/ApiViewer
//
//  Created by Douglas Adams on 1/24/22.
//

import SwiftUI
import ComposableArchitecture

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct MeterView: View {
  @ObservedObject var model: Model
  let sliceId: UInt32?
  let sliceClientHandle: UInt32?
  let handle: Handle

  func valueColor(_ value: Float, _ low: Float, _ high: Float) -> Color {
    if value > high { return .red }
    if value < low { return .yellow }
    return .green
  }

  func showMeter(_ id: UInt32?, _ clientHandle: UInt32?, _ source: String, _ group: String) -> Bool {
    if id == nil { return true }
    if clientHandle != handle { return false }
    if source != "slc" { return false }
    if UInt32(group) != id { return false }
    return true
  }

  var body: some View {

      VStack(alignment: .leading) {
        ForEach(model.meters ) { meter in

          if showMeter(sliceId, sliceClientHandle, meter.source, meter.group) {
            HStack(spacing: 10) {
              Group {
                Text("Meter").padding(.leading, sliceId == nil ? 0 : 80)
                Text(String(format: "% 3d", meter.id)).frame(width: 40, alignment: .trailing)
                if sliceId == nil {
                  Text(meter.group).frame(width: 30, alignment: .trailing)
                  Text(meter.source).frame(width: 40, alignment: .leading)
                }
                Text(meter.name).frame(width: 110, alignment: .leading)
              }
              Group {
                Text(String(format: "%-4.2f", meter.value))
                  .help("        range: \(String(format: "%-4.2f", meter.low)) to \(String(format: "%-4.2f", meter.high))")
                  .foregroundColor(valueColor(meter.value, meter.low, meter.high))
                  .frame(width: 75, alignment: .trailing)
                Text(meter.units).frame(width: 50, alignment: .leading)
                Text(String(format: "% 2d", meter.fps) + " fps").frame(width: 70, alignment: .leading)
                Text(meter.desc).foregroundColor(.primary)
              }
            }
        }
      }
      .foregroundColor(.secondary)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct MeterView_Previews: PreviewProvider {
  static var previews: some View {
    MeterView(model: Model.shared, sliceId: 1, sliceClientHandle: nil, handle: 1)
    .frame(minWidth: 1000)
    .padding()
  }
}
