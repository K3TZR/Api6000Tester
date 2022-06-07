//
//  WaveformView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI
import ComposableArchitecture

// ----------------------------------------------------------------------------
// MARK: - View

struct WaveformView: View {
  let store: Store<ApiState, ApiAction>

  var body: some View {
    WithViewStore(store.actionless) { viewStore in
      if viewStore.radio != nil {
        
        HStack(spacing: 20) {
          Text("WAVEFORM -> ").frame(width: 140, alignment: .leading)
          Text("WAVEFORM NOT IMPLEMENTED")
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000
import TcpCommands
import UdpStreams
import Shared

struct WaveformViewPreviews: PreviewProvider {
  static var previews: some View {
    WaveformView(
      store: Store(
        initialState: ApiState(
          radio: Radio(Packet(),
                       connectionType: .gui,
                       command: Tcp(),
                       stream: Udp())
        ),
        reducer: apiReducer,
        environment: ApiEnvironment()
      )
    )
    .frame(minWidth: 975)
    .padding()
  }
}
