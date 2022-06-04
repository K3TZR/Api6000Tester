//
//  MemoriesView.swift
//  Components6000/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

// ----------------------------------------------------------------------------
// MARK: - View

import SwiftUI
import ComposableArchitecture

struct MemoriesView: View {
  let store: Store<ApiState, ApiAction>
  
  var body: some View {
    
    HStack(spacing: 20) {
      Text("MEMORIES -> ").frame(width: 140, alignment: .leading)
      Text("MEMORIES NOT IMPLEMENTED")
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000
import TcpCommands
import UdpStreams
import Shared

struct MemoriesView_Previews: PreviewProvider {
  static var previews: some View {
    MemoriesView(
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
