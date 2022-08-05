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
      
//      if api6000.remoteRxAudioStreams.count == 0 {
//        Text("         REMOTE Rx -> None present").foregroundColor(.red)
//      } else {
        ForEach(api6000.remoteRxAudioStreams) { stream in
          if handle == stream.clientHandle {
            HStack(spacing: 20) {
              HStack(spacing: 5) {
                Text("         REMOTE Rx ")
                Text(stream.id.hex).foregroundColor(.secondary)
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
//      }

//      if api6000.remoteTxAudioStreams.count == 0 {
//        Text("         REMOTE Tx -> None present").foregroundColor(.red)
//      } else {
        ForEach(api6000.remoteTxAudioStreams) { stream in
          if api6000.radio!.connectionHandle == stream.clientHandle {
            HStack(spacing: 20) {
              Text("         REMOTE Tx -> ")
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
//      }
      
//      if api6000.daxMicAudioStreams.count == 0 {
//        Text("         DAX MIC   -> None present").foregroundColor(.red)
//      } else {
        ForEach(api6000.daxMicAudioStreams) { stream in
          if api6000.radio!.connectionHandle == stream.clientHandle {
            HStack(spacing: 20) {
              Text("         DAX MIC -> ")
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
//      }
      
//      if api6000.daxRxAudioStreams.count == 0 {
//        Text("         DAX RX    -> None present").foregroundColor(.red)
//      } else {
        ForEach(api6000.daxRxAudioStreams) { stream in
          if api6000.radio!.connectionHandle == stream.clientHandle {
            HStack(spacing: 20) {
              Text("         DAX RX -> ")
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
//      }
      
//      if api6000.daxTxAudioStreams.count == 0 {
//        Text("         DAX TX    -> None present").foregroundColor(.red)
//      } else {
        ForEach(api6000.daxTxAudioStreams) { stream in
          if api6000.radio!.connectionHandle == stream.clientHandle {
            HStack(spacing: 20) {
              Text("         DAX TX -> ")
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
//      }
      
//      if api6000.daxIqStreams.count == 0 {
//        Text("         DAX IQ    -> None present").foregroundColor(.red)
//      } else {
        ForEach(api6000.daxIqStreams) { stream in
          if api6000.radio!.connectionHandle == stream.clientHandle {
            HStack(spacing: 20) {
              Text("         DAX IQ -> ")
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
//      }
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
