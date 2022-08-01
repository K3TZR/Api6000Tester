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
  @EnvironmentObject var model: Model
  let handle: Handle
  
  var body: some View {
    
    VStack(alignment: .leading) {
      ForEach(model.remoteRxAudioStreams) { stream in
        if handle == stream.clientHandle {
          HStack(spacing: 20) {
            Text("RemoteRx").frame(width: 100, alignment: .trailing)
            Text(stream.id.hex).foregroundColor(.secondary)
            HStack(spacing: 5) {
              Text("Handle")
              Text("\(stream.clientHandle.hex)").foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Compression")
              Text("\(stream.compression)").foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Ip")
              Text("\(stream.ip)").foregroundColor(.secondary)
            }
          }
        }
      }
      ForEach(model.remoteTxAudioStreams) { stream in
        if model.radio!.connectionHandle == stream.clientHandle {
          HStack(spacing: 20) {
            Text("RemoteTx").frame(width: 100, alignment: .trailing)
            Text(stream.id.hex).foregroundColor(.secondary)
            HStack(spacing: 5) {
              Text("Handle")
              Text("\(stream.clientHandle.hex)").foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Compression")
              Text("\(stream.compression)").foregroundColor(.secondary)
            }
          }
        }
      }
      ForEach(model.daxMicAudioStreams) { stream in
        if model.radio!.connectionHandle == stream.clientHandle {
          HStack(spacing: 20) {
            Text("DaxMic").frame(width: 100, alignment: .trailing)
            Text(stream.id.hex).foregroundColor(.secondary)
            HStack(spacing: 5) {
              Text("Handle")
              Text("\(stream.clientHandle.hex)").foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Ip")
              Text("\(stream.ip)").foregroundColor(.secondary)
            }
          }
        }
      }
      ForEach(model.daxRxAudioStreams) { stream in
        if model.radio!.connectionHandle == stream.clientHandle {
          HStack(spacing: 20) {
            Text("DaxRx").frame(width: 100, alignment: .trailing)
            Text(stream.id.hex).foregroundColor(.secondary)
            HStack(spacing: 5) {
              Text("Handle")
              Text("\(stream.clientHandle.hex)").foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Channel")
              Text("\(stream.daxChannel)").foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Ip")
              Text("\(stream.ip)").foregroundColor(.secondary)
            }
          }
        }
      }
      ForEach(model.daxTxAudioStreams) { stream in
        if model.radio!.connectionHandle == stream.clientHandle {
          HStack(spacing: 20) {
            Text("DaxTx").frame(width: 100, alignment: .trailing)
            Text("\(stream.id.hex)").foregroundColor(.secondary)
            HStack(spacing: 5) {
              Text("ClientHandle")
              Text("\(stream.clientHandle.hex)").foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Transmit")
              Text(stream.isTransmitChannel ? "Y" : "N").foregroundColor(stream.isTransmitChannel ? .green : .red)
            }
          }
        }
      }
      ForEach(model.daxIqStreams) { stream in
        if model.radio!.connectionHandle == stream.clientHandle {
          HStack(spacing: 20) {
            Text("DaxIq").frame(width: 100, alignment: .trailing)
            Text(stream.id.hex).foregroundColor(.secondary)
            HStack(spacing: 5) {
              Text("Handle")
              Text("\(stream.clientHandle.hex)").foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Channel")
              Text("\(stream.channel)").foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Ip")
              Text("\(stream.ip)").foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Pan")
              Text("\(stream.pan.hex)").foregroundColor(.secondary)
            }
          }
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct StreamView_Previews: PreviewProvider {
  static var previews: some View {
    StreamView(handle: 1 )
    .frame(minWidth: 975)
    .padding()
  }
}
