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
    VStack(alignment: .leading) {
      // Panadapter
      ForEach(viewModel.panadapters) { panadapter in
        if handle == panadapter.clientHandle { PanadapterStreamView(panadapter: panadapter) }
      }
      
      // Waterfall
      ForEach(viewModel.waterfalls) { waterfall in
        if handle == waterfall.clientHandle { WaterfallStreamView(waterfall: waterfall) }
      }
      
      // RemoteRxAudioStream
      ForEach(streamModel.remoteRxAudioStreams) { stream in
        if handle == stream.clientHandle { RemoteRxStreamView(stream: stream) }
      }
      
      // RemoteTxAudioStream
      ForEach(streamModel.remoteTxAudioStreams) { stream in
        if handle == stream.clientHandle { RemoteTxStreamView(stream: stream) }
      }
      
      // DaxMicAudioStream
      ForEach(streamModel.daxMicAudioStreams) { stream in
        if handle == stream.clientHandle { DaxMicStreamView(stream: stream) }
      }
      
      // DaxRxAudioStream
      ForEach(streamModel.daxRxAudioStreams) { stream in
        if handle == stream.clientHandle { DaxRxStreamView(stream: stream) }
      }
      
      // DaxTxAudioStream
      ForEach(streamModel.daxTxAudioStreams) { stream in
        if handle == stream.clientHandle { DaxTxStreamView(stream: stream) }
      }
      
      // DaxIqStream
      ForEach(streamModel.daxIqStreams) { stream in
        if handle == stream.clientHandle { DaxIqStreamView(stream: stream) }
      }
    }
    .padding(.leading, 40)
  }
}

struct PanadapterStreamView: View {
  @ObservedObject var panadapter: Panadapter
  
  var body: some View {
    HStack(spacing: 20) {
      Text("PANADAPTER").frame(width: 80, alignment: .leading)
      
      Group {
        HStack(spacing: 5) {
          Text("Streaming")
          Text(panadapter.isStreaming ? "Y" : "N").foregroundColor(panadapter.isStreaming ? .green : .red)
        }
        
        HStack(spacing: 5) {
          Text("Id")
          Text(panadapter.isStreaming ? panadapter.id.hex : "0x--------").padding(.leading, 5).foregroundColor(.secondary)
        }
      }.frame(width: 100, alignment: .leading)
    }
  }
}

struct WaterfallStreamView: View {
  @ObservedObject var waterfall: Waterfall
  
  var body: some View {
    HStack(spacing: 20) {
      Text("WATERFALL").frame(width: 80, alignment: .leading)
      
      Group {
        HStack(spacing: 5) {
          Text("Streaming")
          Text(waterfall.isStreaming ? "Y" : "N").foregroundColor(waterfall.isStreaming ? .green : .red)
        }
        
        HStack(spacing: 5) {
          Text("Id")
          Text(waterfall.isStreaming ? waterfall.id.hex : "0x--------").padding(.leading, 5).foregroundColor(.secondary)
        }
      }.frame(width: 100, alignment: .leading)
    }
  }
}

struct RemoteRxStreamView: View {
  @ObservedObject var stream: RemoteRxAudioStream
  
  var body: some View {
    HStack(spacing: 20) {
      Text("REMOTE Rx").frame(width: 80, alignment: .leading)
      
      Group {
        HStack(spacing: 5) {
          Text("Streaming")
          Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
        }
        
        HStack(spacing: 5) {
          Text("Id")
          Text(stream.isStreaming ? stream.id.hex : "0x--------").padding(.leading, 5).foregroundColor(.secondary)
        }
      }.frame(width: 100, alignment: .leading)

      Group {
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
      }.frame(width: 150, alignment: .leading)
    }
  }
}

struct RemoteTxStreamView: View {
  @ObservedObject var stream: RemoteTxAudioStream
  
  var body: some View {
    HStack(spacing: 20) {
      Text("REMOTE Tx").frame(width: 80, alignment: .leading)
      
      Group {
        HStack(spacing: 5) {
          Text("Streaming")
          Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
        }
        
        HStack(spacing: 5) {
          Text("Id")
          Text(stream.isStreaming ? stream.id.hex : "0x--------").padding(.leading, 5).foregroundColor(.secondary)
        }
      }.frame(width: 100, alignment: .leading)

      Group {
        HStack(spacing: 5) {
          Text("Handle")
          Text("\(stream.clientHandle.hex)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Compression")
          Text("\(stream.compression)").foregroundColor(.secondary)
        }
      }.frame(width: 150, alignment: .leading)
    }
  }
}

struct DaxMicStreamView: View {
  @ObservedObject var stream: DaxMicAudioStream
  
  var body: some View {
    HStack(spacing: 20) {
      Text("DAX Mic").frame(width: 80, alignment: .leading)
      
      Group {
        HStack(spacing: 5) {
          Text("Streaming")
          Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
        }
        
        HStack(spacing: 5) {
          Text("Id")
          Text(stream.isStreaming ? stream.id.hex : "0x--------").padding(.leading, 5).foregroundColor(.secondary)
        }
      }.frame(width: 100, alignment: .leading)

      Group {
        HStack(spacing: 5) {
          Text("Handle")
          Text("\(stream.clientHandle.hex)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Ip")
          Text("\(stream.ip)").foregroundColor(.secondary)
        }
      }.frame(width: 150, alignment: .leading)
    }
  }
}

struct DaxRxStreamView: View {
  @ObservedObject var stream: DaxRxAudioStream
  
  var body: some View {
    HStack(spacing: 20) {
      Text("DAX Rx").frame(width: 80, alignment: .leading)
      
      Group {
        HStack(spacing: 5) {
          Text("Streaming")
          Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
        }
        
        HStack(spacing: 5) {
          Text("Id")
          Text(stream.isStreaming ? stream.id.hex : "0x--------").padding(.leading, 5).foregroundColor(.secondary)
        }
      }.frame(width: 100, alignment: .leading)

      Group {
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
      }.frame(width: 150, alignment: .leading)
    }
  }
}

struct DaxTxStreamView: View {
  @ObservedObject var stream: DaxTxAudioStream
  
  var body: some View {
    HStack(spacing: 20) {
      Text("DAX Tx").frame(width: 80, alignment: .leading)
      
      Group {
        HStack(spacing: 5) {
          Text("Streaming")
          Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
        }
        
        HStack(spacing: 5) {
          Text("Id")
          Text(stream.isStreaming ? stream.id.hex : "0x--------").padding(.leading, 5).foregroundColor(.secondary)
        }
      }.frame(width: 100, alignment: .leading)

      Group {
        HStack(spacing: 5) {
          Text("Handle")
          Text("\(stream.clientHandle.hex)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Ip")
          Text("\(stream.ip)").foregroundColor(.secondary)
        }

        HStack(spacing: 5) {
          Text("Transmit")
          Text("\(stream.isTransmitChannel ? "Y" : "N")").foregroundColor(stream.isTransmitChannel ? .green : .red)
        }

      }.frame(width: 150, alignment: .leading)
    }
  }
}

struct DaxIqStreamView: View {
  @ObservedObject var stream: DaxIqStream
  
  var body: some View {
    HStack(spacing: 20) {
      Text("DAX IQ").frame(width: 80, alignment: .leading)
      
      Group {
        HStack(spacing: 5) {
          Text("Streaming")
          Text(stream.isStreaming ? "Y" : "N").foregroundColor(stream.isStreaming ? .green : .red)
        }
        
        HStack(spacing: 5) {
          Text("Id")
          Text(stream.isStreaming ? stream.id.hex : "0x--------").padding(.leading, 5).foregroundColor(.secondary)
        }
      }.frame(width: 100, alignment: .leading)

      Group {
        HStack(spacing: 5) {
          Text("Handle")
          Text("\(stream.clientHandle.hex)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Ip")
          Text("\(stream.ip)").foregroundColor(.secondary)
        }

        HStack(spacing: 5) {
          Text("Channel")
          Text("\(stream.channel)").foregroundColor(.secondary)
        }

        HStack(spacing: 5) {
          Text("Pan")
          Text(stream.pan.hex).foregroundColor(.secondary)
        }

      }.frame(width: 150, alignment: .leading)
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
