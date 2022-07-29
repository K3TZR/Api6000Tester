//
//  StreamView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct StreamView: View {
  @ObservedObject var model: Model
  
  var body: some View {
    
    VStack(alignment: .leading) {
      ForEach(model.remoteRxAudioStreams) { stream in
        if model.radio!.connectionHandle == stream.clientHandle {
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
      ForEach(model.remoteTxAudioStreams) { stream in
        if model.radio!.connectionHandle == stream.clientHandle {
          HStack(spacing: 20) {
            Text("RemoteTxAudioStream")
            Text(stream.id.hex)
            Text("Handle \(stream.clientHandle.hex)")
            Text("Compression \(stream.compression)")
          }
          .foregroundColor(.orange)
        }
      }
      ForEach(model.daxMicAudioStreams) { stream in
        if model.radio!.connectionHandle == stream.clientHandle {
          HStack(spacing: 20) {
            Text("DaxMicAudioStream")
            Text(stream.id.hex)
            Text("Handle \(stream.clientHandle.hex)")
            Text("Ip \(stream.ip)")
          }
          .foregroundColor(.yellow)
        }
      }
      ForEach(model.daxRxAudioStreams) { stream in
        if model.radio!.connectionHandle == stream.clientHandle {
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
      ForEach(model.daxTxAudioStreams) { stream in
        if model.radio!.connectionHandle == stream.clientHandle {
          HStack(spacing: 20) {
            Text("DaxTxAudioStream")
            Text("Id=\(stream.id.hex)")
            Text("ClientHandle=\(stream.clientHandle.hex)")
            Text("Transmit=\(stream.isTransmitChannel ? "Y" : "N")")
          }
          .foregroundColor(.blue)
        }
      }
      ForEach(model.daxIqStreams) { stream in
        if model.radio!.connectionHandle == stream.clientHandle {
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

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000


import Shared

struct StreamView_Previews: PreviewProvider {
  static var previews: some View {
    StreamView(model: Model.shared )
    .frame(minWidth: 975)
    .padding()
  }
}
