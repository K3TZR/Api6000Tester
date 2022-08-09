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
  @ObservedObject var api6000: Model
  let handle: Handle
  
  var body: some View {
    
    VStack(alignment: .leading) {
      
      // Panadapter
      ForEach(api6000.panadapters) { panadapter in
        if handle == panadapter.clientHandle {
          HStack(spacing: 20) {
            HStack(spacing: 5) {
              Text("         PANADAPTER Stream").foregroundColor(.blue)
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
      ForEach(api6000.waterfalls) { waterfall in
        if handle == waterfall.clientHandle {
          HStack(spacing: 20) {
            HStack(spacing: 5) {
              Text("         WATERFALL  Stream").foregroundColor(.blue)
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
      
      // Meter
      if Meter.streamId != nil {
        HStack(spacing: 20) {
          HStack(spacing: 5) {
            Text("         METERS     Stream").foregroundColor(.blue)
            Text(Meter.streamId!.hex).foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("Streaming")
            Text(Meter.isStreaming ? "Y" : "N").foregroundColor(Meter.isStreaming ? .green : .red)
          }
        }
      }
      
      // RemoteRxAudioStream
      ForEach(api6000.remoteRxAudioStreams) { stream in
        if handle == stream.clientHandle {
          HStack(spacing: 20) {
            HStack(spacing: 5) {
              Text("         REMOTE Rx  Stream").foregroundColor(.blue)
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
      ForEach(api6000.remoteTxAudioStreams) { stream in
        if handle == stream.clientHandle {
          HStack(spacing: 20) {
            HStack(spacing: 5) {
              Text("         REMOTE Tx  Stream").foregroundColor(.blue)
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
      ForEach(api6000.daxMicAudioStreams) { stream in
        if handle == stream.clientHandle {
          HStack(spacing: 20) {
            HStack(spacing: 5) {
              Text("         DAX MIC    Stream").foregroundColor(.blue)
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
      ForEach(api6000.daxRxAudioStreams) { stream in
        if handle == stream.clientHandle {
          HStack(spacing: 20) {
            HStack(spacing: 5) {
              Text("         DAX RX     Stream").foregroundColor(.blue)
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
      ForEach(api6000.daxTxAudioStreams) { stream in
        if handle == stream.clientHandle {
          HStack(spacing: 20) {
            HStack(spacing: 5) {
              Text("         DAX TX     Stream").foregroundColor(.blue)
              Text("\(stream.id.hex)").foregroundColor(.secondary)
            }
            
            HStack(spacing: 5) {
              Text("Streaming")
              Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
            }
            
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
      
      // DaxIqStream
      ForEach(api6000.daxIqStreams) { stream in
        if handle == stream.clientHandle {
          HStack(spacing: 20) {
            HStack(spacing: 5) {
              Text("         DAX IQ     Stream").foregroundColor(.blue)
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
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct StreamView_Previews: PreviewProvider {
  static var previews: some View {
    StreamView(api6000: Model.shared, handle: 1)
      .frame(minWidth: 1000)
      .padding()
  }
}
