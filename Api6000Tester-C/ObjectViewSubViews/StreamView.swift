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
  @ObservedObject var viewModel: ViewModel
  @ObservedObject var streamModel: StreamModel
  let handle: Handle
    
  var body: some View {
    
    // Panadapter
    ForEach(viewModel.panadapters) { panadapter in
      if handle == panadapter.clientHandle {
        HStack(spacing: 20) {
          HStack(spacing: 5) {
            Text("        PANADAPTER Stream").foregroundColor(.blue)
            Text(panadapter.id.hex).foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("Streaming")
            Text(panadapter.isStreaming ? "Y" : "N").foregroundColor(panadapter.isStreaming ? .green : .red)
          }
          
          HStack(spacing: 5) {
            Text("Handle")
            Text("\(panadapter.clientHandle.hex)").foregroundColor(.secondary)
          }
        }
      }
    }
    
    // Waterfall
    ForEach(viewModel.waterfalls) { waterfall in
      if handle == waterfall.clientHandle {
        HStack(spacing: 20) {
          HStack(spacing: 5) {
            Text("        WATERFALL  Stream").foregroundColor(.blue)
            Text(waterfall.id.hex).foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("Streaming")
            Text(waterfall.isStreaming ? "Y" : "N").foregroundColor(waterfall.isStreaming ? .green : .red)
          }
          
          HStack(spacing: 5) {
            Text("Handle")
            Text("\(waterfall.clientHandle.hex)").foregroundColor(.secondary)
          }
        }
      }
    }
    
    // RemoteRxAudioStream
    ForEach(streamModel.remoteRxAudioStreams) { stream in
      if handle == stream.clientHandle {
        HStack(spacing: 20) {
          HStack(spacing: 5) {
            Text("        REMOTE Rx  Stream").foregroundColor(.blue)
            Text(stream.id.hex).foregroundColor(.secondary)
          }

          HStack(spacing: 5) {
            Text("Streaming")
            Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
          }

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
    
    // RemoteTxAudioStream
    ForEach(streamModel.remoteTxAudioStreams) { stream in
      if handle == stream.clientHandle {
        HStack(spacing: 20) {
          HStack(spacing: 5) {
            Text("        REMOTE Tx  Stream").foregroundColor(.blue)
            Text(stream.id.hex).foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("Streaming")
            Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
          }
          
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
    
    // DaxMicAudioStream
    ForEach(streamModel.daxMicAudioStreams) { stream in
      if handle == stream.clientHandle {
        HStack(spacing: 20) {
          HStack(spacing: 5) {
            Text("        DAX MIC    Stream").foregroundColor(.blue)
            Text(stream.id.hex).foregroundColor(.secondary)
          }

          HStack(spacing: 5) {
            Text("Streaming")
            Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
          }

          HStack(spacing: 5) {
            Text("Handle")
            Text("\(stream.clientHandle.hex)").foregroundColor(.secondary)
          }

          HStack(spacing: 5) {
            Text("Ip")
            Text("\(stream.ip)").foregroundColor(.secondary)
          }

          HStack(spacing: 5) {
            Text("Streaming")
            Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
          }
        }
      }
    }
    
    // DaxRxAudioStream
    ForEach(streamModel.daxRxAudioStreams) { stream in
      if handle == stream.clientHandle {
        HStack(spacing: 20) {
          HStack(spacing: 5) {
            Text("        DAX RX     Stream").foregroundColor(.blue)
            Text(stream.id.hex).foregroundColor(.secondary)
          }

          HStack(spacing: 5) {
            Text("Streaming")
            Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
          }

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
    
    
    // DaxTxAudioStream
    ForEach(streamModel.daxTxAudioStreams) { stream in
      if handle == stream.clientHandle {
        HStack(spacing: 20) {
          HStack(spacing: 5) {
            Text("        DAX TX     Stream").foregroundColor(.blue)
            Text("\(stream.id.hex)").foregroundColor(.secondary)
          }

          HStack(spacing: 5) {
            Text("Streaming")
            Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
          }

          HStack(spacing: 5) {
            Text("Client_Handle")
            Text("\(stream.clientHandle.hex)").foregroundColor(.secondary)
          }

          HStack(spacing: 5) {
            Text("Transmit")
            Text(stream.isTransmitChannel ? "Y" : "N").foregroundColor(stream.isTransmitChannel ? .green : .red)
          }
        }
      }
    }
    
    // DaxIqStream
    ForEach(streamModel.daxIqStreams) { stream in
      if handle == stream.clientHandle {
        HStack(spacing: 20) {
          HStack(spacing: 5) {
            Text("        DAX IQ     Stream").foregroundColor(.blue)
            Text(stream.id.hex).foregroundColor(.secondary)
          }

          HStack(spacing: 5) {
            Text("Streaming")
            Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
          }

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

// ----------------------------------------------------------------------------
// MARK: - Preview

struct StreamView_Previews: PreviewProvider {
  static var previews: some View {
    StreamView(viewModel: ViewModel.shared, streamModel: StreamModel.shared, handle: 1)
      .frame(minWidth: 1000)
      .padding()
  }
}
