//
//  GuiClientView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import ComposableArchitecture
import SwiftUI

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct GuiClientView: View {
  let store: Store<ApiState, ApiAction>
  @ObservedObject var packets: Packets
  @ObservedObject var viewModel: ViewModel
  @ObservedObject var streamModel: StreamModel

  var body: some View {
    if viewModel.activePacket == nil {
      EmptyView()
    } else {
      VStack(alignment: .leading) {
        ForEach(packets.guiClients, id: \.id) { guiClient in
          Divider().background(Color(.red))
          HStack(spacing: 10) {
            
//            HStack(spacing: 0) {
              Text("\(guiClient.station) Gui").foregroundColor(.yellow).frame(width: 50, alignment: .leading)
//              Text("Station ")
//              Text("\(guiClient.station)").foregroundColor(.secondary)
//            }
            
            HStack(spacing: 5) {
              Text("Program")
              Text("\(guiClient.program)").foregroundColor(.secondary)
            }
            
            HStack(spacing: 5) {
              Text("Handle")
              Text(guiClient.handle.hex).foregroundColor(.secondary)
            }
            
            HStack(spacing: 5) {
              Text("ClientId")
              Text(guiClient.clientId ?? "Unknown").foregroundColor(.secondary)
            }
            
            HStack(spacing: 5) {
              Text("LocalPtt")
              Text(guiClient.isLocalPtt ? "Y" : "N").foregroundColor(guiClient.isLocalPtt ? .green : .red)
            }
          }
          GuiClientSubView(store: store, viewModel: viewModel, streamModel: streamModel, handle: guiClient.handle)
        }
      }
      .padding(.bottom, 10)
    }
  }
}

struct GuiClientSubView: View {
  let store: Store<ApiState, ApiAction>
  @ObservedObject var viewModel: ViewModel
  @ObservedObject var streamModel: StreamModel
  let handle: Handle
  
  var body: some View {
    
    WithViewStore(store) {viewStore in
      switch viewStore.objectFilter {
        
      case ObjectFilter.core:
        PanadapterView(viewModel: viewModel, handle: handle, showMeters: true)
        
      case ObjectFilter.coreNoMeters:
        PanadapterView(viewModel: viewModel, handle: handle, showMeters: false)
        
      case ObjectFilter.amplifiers:        AmplifierView(viewModel: viewModel)
      case ObjectFilter.bandSettings:      BandSettingView(viewModel: viewModel)
      case ObjectFilter.cwx:               CwxView(viewModel: viewModel)
      case ObjectFilter.equalizers:        EqualizerView(viewModel: viewModel)
      case ObjectFilter.interlock:         InterlockView(viewModel: viewModel)
      case ObjectFilter.memories:          MemoryView(viewModel: viewModel)
      case ObjectFilter.meters:            MeterView(viewModel: viewModel, sliceId: nil, sliceClientHandle: nil, handle: handle)
      case ObjectFilter.profiles:          ProfileView(viewModel: viewModel)
      case ObjectFilter.streams:           StreamView(viewModel: viewModel, streamModel: streamModel, handle: handle)
      case ObjectFilter.transmit:          TransmitView(viewModel: viewModel)
      case ObjectFilter.usbCable:          UsbCableView(viewModel: viewModel)
      case ObjectFilter.wan:               WanView(viewModel: viewModel)
      case ObjectFilter.waveforms:         WaveformView(viewModel: viewModel)
      case ObjectFilter.xvtrs:             XvtrView(viewModel: viewModel)
//      default:    EmptyView()
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct GuiClientView_Previews: PreviewProvider {
  static var previews: some View {
    GuiClientView( store:
                    Store(initialState: ApiState(),
                          reducer: apiReducer,
                          environment: ApiEnvironment()),
                   packets: Packets.shared,
                   viewModel: ViewModel.shared,
                   streamModel: StreamModel.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
