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
  let store: Store<ApiState, ApiAction>
  let sliceId: ObjectId?
  
  func valueColor(_ value: Float, _ low: Float, _ high: Float) -> Color {
    if value > high { return .red }
    if value < low { return .yellow }
    return .green
  }

  var body: some View {
    
    WithViewStore(store) { viewStore in
      VStack(alignment: .leading) {
        ForEach(Model.shared.meters ) { meter in
          if sliceId == nil || sliceId != nil && meter.source == "slc" && UInt16(meter.group) == sliceId {
            HStack(spacing: 0) {
              Text("Meter").padding(.leading, sliceId == nil ? 20: 40)
              Text(String(format: "% 3d", meter.id)).frame(width: 50, alignment: .leading)
              Text(meter.group).frame(width: 30, alignment: .trailing).padding(.trailing)
              Text(meter.name).frame(width: 110, alignment: .leading)
              Text(String(format: "%-4.2f", meter.low)).frame(width: 75, alignment: .trailing)
              Text(String(format: "%-4.2f", meter.value))
                .foregroundColor(valueColor(meter.value, meter.low, meter.high))
                .frame(width: 75, alignment: .trailing)
              Text(String(format: "%-4.2f", meter.high)).frame(width: 75, alignment: .trailing)
              Text(meter.units).frame(width: 50, alignment: .leading)
              Text(String(format: "%02d", meter.fps) + " fps").frame(width: 75, alignment: .leading).padding(.trailing)
              Text(meter.desc)
                .frame(width: 1000, alignment: .leading)
            }
          }
        }
      }
      .foregroundColor(.secondary)
//      .onAppear() { viewStore.send(.startMetersSubscription) }
//      .onDisappear() { viewStore.send(.stopMetersSubscription) }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000
import TcpCommands
import UdpStreams
import Shared

struct MeterView_Previews: PreviewProvider {
  static var previews: some View {
    MeterView(
      store: Store(
        initialState: ApiState(
          radio: Radio(Packet(),
                       connectionType: .gui,
                       command: Tcp(),
                       stream: Udp())
        ),
        reducer: apiReducer,
        environment: ApiEnvironment()
      ), sliceId: 1
    )
    .frame(minWidth: 975)
    .padding()
  }
}
