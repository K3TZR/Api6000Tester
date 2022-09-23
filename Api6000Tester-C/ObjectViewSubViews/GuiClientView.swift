//
//  GuiClientView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI
import ComposableArchitecture

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct GuiClientView: View {
  let store: Store<ApiState, ApiAction>
  @ObservedObject var model: Model
  
  var body: some View {
    if model.activePacketId == nil {
      EmptyView()
    } else {
      VStack(alignment: .leading) {
        ForEach(model.guiClients, id: \.id) { guiClient in
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
          GuiClientSubView(store: store, model: model, handle: guiClient.handle)
        }
      }
      .padding(.bottom, 10)
    }
  }
}

struct GuiClientSubView: View {
  let store: Store<ApiState, ApiAction>
  @ObservedObject var model: Model
  let handle: Handle
  
  var body: some View {
    
    WithViewStore(store) {viewStore in
      switch viewStore.objectFilter {
        
      case ObjectFilter.core:
        PanadapterView(model: model, handle: handle, showMeters: true)
        
      case ObjectFilter.coreNoMeters:
        PanadapterView(model: model, handle: handle, showMeters: false)
        
      case ObjectFilter.amplifiers:        AmplifierView(model: model)
      case ObjectFilter.bandSettings:      BandSettingView(model: model)
      case ObjectFilter.cwx:               CwxView(model: model)
      case ObjectFilter.equalizers:        EqualizerView(model: model)
      case ObjectFilter.interlock:         InterlockView(model: model)
      case ObjectFilter.memories:          MemoryView(model: model)
      case ObjectFilter.meters:            MeterView(model: model, sliceId: nil, sliceClientHandle: nil, handle: handle)
      case ObjectFilter.profiles:          ProfileView(model: model)
      case ObjectFilter.streams:           StreamView(model: model, handle: handle)
      case ObjectFilter.transmit:          TransmitView(model: model)
      case ObjectFilter.usbCable:          UsbCableView(model: model)
      case ObjectFilter.wan:               WanView(model: model)
      case ObjectFilter.waveforms:         WaveformView(model: model)
      case ObjectFilter.xvtrs:             XvtrView(model: model)
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
                   model: Model.shared )
      .frame(minWidth: 1000)
      .padding()
  }
}
