//
//  GuiClientView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI
import ComposableArchitecture

import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct GuiClientsView: View {
  let store: Store<ApiState, ApiAction>
  
  var body: some View {
    WithViewStore(store.actionless) { viewStore in
      
      ForEach(viewStore.radio!.packet.guiClients, id: \.id) { guiClient in
        Divider().background(Color(.red))
        HStack(spacing: 20) {
          Text("GUI CLIENT -> ").frame(width: 140, alignment: .leading)
          Text("\(guiClient.program) / \(guiClient.station)").frame(width: 220, alignment: .leading)
          Text("Handle \(guiClient.handle.hex)")
          Text("ClientId \(guiClient.clientId ?? "Unknown")")
          Text("LocalPtt \(guiClient.isLocalPtt ? "Y" : "N")")
        }
        GuiClientSubView(store: store, handle: guiClient.handle)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

struct GuiClientSubView: View {
  let store: Store<ApiState, ApiAction>
  let handle: Handle
  
  var body: some View {
    WithViewStore(store.actionless) { viewStore in
      
      switch viewStore.objectsFilterBy {
        
      case .core:
        StreamView(store: store)
        PanadapterView(store: store, handle: handle, showMeters: true)
        
      case .coreNoMeters:
        StreamView(store: store)
        PanadapterView(store: store, handle: handle, showMeters: false)
        
      case .amplifiers:       AmplifierView(store: store)
      case .bandSettings:     BandSettingsView(store: store)
      case .interlock:        InterlockView(store: store)
      case .memories:         MemoriesView(store: store)
      case .meters:           MeterView(store: store, sliceId: nil)
      case .streams:          StreamView(store: store)
      case .transmit:         TransmitView(store: store)
      case .tnfs:             TnfView(store: store)
      case .waveforms:        WaveformView(store: store)
      case .xvtrs:            XvtrView(store: store)
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

struct GuiClientsView_Previews: PreviewProvider {
  static var previews: some View {
    GuiClientsView(
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
