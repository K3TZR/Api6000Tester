//
//  BandSettingsView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI
import ComposableArchitecture

// ----------------------------------------------------------------------------
// MARK: - View

struct BandSettingsView: View {
  let store: Store<ApiState, ApiAction>
  
  var body: some View {
    
    HStack(spacing: 20) {
      Text("BANDSETTINGS -> ").frame(width: 140, alignment: .leading)
      Text("BANDSETTINGS NOT IMPLEMENTED")
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000
import TcpCommands
import UdpStreams
import Shared

struct BandSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    BandSettingsView(
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
