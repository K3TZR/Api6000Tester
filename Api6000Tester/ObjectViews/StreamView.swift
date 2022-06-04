//
//  StreamView.swift
//  Components6000/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI
import ComposableArchitecture

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct StreamView: View {
  let store: Store<ApiState, ApiAction>
  
  var body: some View {
    WithViewStore(store.actionless) { viewStore in
      
      VStack(alignment: .leading) {
        ForEach(Model.shared.remoteRxAudioStreams) { stream in
          if viewStore.radio!.connectionHandle == stream.clientHandle {
            HStack(spacing: 20) {
              Text("RemoteRxAudioStream")
              Text(stream.id.hex)
              Text("Handle \(stream.clientHandle.hex)")
              Text("Compression \(stream.compression)")
              Text("Ip \(stream.ip)")
            }
            .foregroundColor(.red)
          }
        }
        ForEach(Model.shared.remoteTxAudioStreams) { stream in
          if viewStore.radio!.connectionHandle == stream.clientHandle {
            HStack(spacing: 20) {
              Text("RemoteTxAudioStream")
              Text(stream.id.hex)
              Text("Handle \(stream.clientHandle.hex)")
              Text("Compression \(stream.compression)")
            }
            .foregroundColor(.orange)
          }
        }
        ForEach(Model.shared.daxMicAudioStreams) { stream in
          if viewStore.radio!.connectionHandle == stream.clientHandle {
            HStack(spacing: 20) {
              Text("DaxMicAudioStream")
              Text(stream.id.hex)
              Text("Handle \(stream.clientHandle.hex)")
              Text("Ip \(stream.ip)")
            }
            .foregroundColor(.yellow)
          }
        }
        ForEach(Model.shared.daxRxAudioStreams) { stream in
          if viewStore.radio!.connectionHandle == stream.clientHandle {
            HStack(spacing: 20) {
              Text("DaxRxAudioStream")
              Text(stream.id.hex)
              Text("Handle \(stream.clientHandle.hex)")
              Text("Channel \(stream.daxChannel)")
              Text("Ip \(stream.ip)")
            }
            .foregroundColor(.green)
          }
        }
        ForEach(Model.shared.daxTxAudioStreams) { stream in
          if viewStore.radio!.connectionHandle == stream.clientHandle {
            HStack(spacing: 20) {
              Text("DaxTxAudioStream")
              Text("Id=\(stream.id.hex)")
              Text("ClientHandle=\(stream.clientHandle.hex)")
              Text("Transmit=\(stream.isTransmitChannel ? "Y" : "N")")
            }
            .foregroundColor(.blue)
          }
        }
        ForEach(Model.shared.daxIqStreams) { stream in
          if viewStore.radio!.connectionHandle == stream.clientHandle {
            HStack(spacing: 20) {
              Text("DaxIqStream")
              Text(stream.id.hex)
              Text("Handle=\(stream.clientHandle.hex)")
              Text("Channel \(stream.channel)")
              Text("Ip \(stream.ip)")
              Text("Pan \(stream.pan.hex)")
            }
            .foregroundColor(.purple)
          }
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

struct StreamView_Previews: PreviewProvider {
  static var previews: some View {
    StreamView(
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
