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
  let store: StoreOf<ApiModule>
  @ObservedObject var packetModel: PacketModel
  
  var body: some View {
    VStack(alignment: .leading) {
      ForEach(packetModel.guiClients, id: \.id) { guiClient in
        DetailView(store: store, guiClient: guiClient)
      }
    }
  }
}

private struct DetailView: View {
  let store: StoreOf<ApiModule>
  @ObservedObject var guiClient: GuiClient
  
  @State var showSubView = true
  
  var body: some View {
    Divider().background(Color(.yellow))
    HStack(spacing: 20) {
      
      HStack(spacing: 0) {
        Image(systemName: showSubView ? "chevron.down" : "chevron.right")
          .help("          Tap to toggle details")
          .onTapGesture(perform: { showSubView.toggle() })
        Text(" Gui   ").foregroundColor(.yellow)
          .font(.title)
          .help("          Tap to toggle details")
          .onTapGesture(perform: { showSubView.toggle() })

        Text("\(guiClient.station)").foregroundColor(.yellow)
      }
      
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
    if showSubView { GuiClientSubView(store: store, handle: guiClient.handle) }
  }
}

struct GuiClientSubView: View {
  let store: StoreOf<ApiModule>
  
  
  
  
  struct ViewState: Equatable {
    let objectFilter: ObjectFilter
    init(state: ApiModule.State) {
      self.objectFilter = state.objectFilter
    }
  }
  
  
  
  
  
  
  @Dependency(\.viewModel) var viewModel
  @Dependency(\.streamModel) var streamModel
  
  let handle: Handle
  
  var body: some View {
    
    WithViewStore(self.store, observe: ViewState.init) { viewStore in
      switch viewStore.objectFilter {
        
      case ObjectFilter.core:
        PanadapterView(viewModel: viewModel, handle: handle, showMeters: true)
        
      case ObjectFilter.coreNoMeters:
        PanadapterView(viewModel: viewModel, handle: handle, showMeters: false)
        
      case ObjectFilter.amplifiers:        AmplifierView(viewModel: viewModel)
      case ObjectFilter.bandSettings:      BandSettingView(viewModel: viewModel)
      case ObjectFilter.cwx:               CwxView(cwx: Cwx.shared)
      case ObjectFilter.equalizers:        EqualizerView(viewModel: viewModel)
      case ObjectFilter.interlock:         InterlockView(interlock: Interlock.shared)
      case ObjectFilter.memories:          MemoryView(viewModel: viewModel)
      case ObjectFilter.meters:            MeterView(viewModel: viewModel, sliceId: nil, sliceClientHandle: nil, handle: handle)
      case ObjectFilter.misc:
        if viewModel.radio != nil {
          MiscView(radio: viewModel.radio!)
        } else {
          EmptyView()
        }
      case ObjectFilter.network:           NetworkView(streamModel: streamModel)
      case ObjectFilter.profiles:          ProfileView(viewModel: viewModel)
      case ObjectFilter.streams:           StreamView(viewModel: viewModel, streamModel: streamModel, handle: handle)
      case ObjectFilter.usbCable:          UsbCableView(viewModel: viewModel)
      case ObjectFilter.wan:               WanView(wan: Wan.shared)
      case ObjectFilter.waveforms:         WaveformView(waveform: Waveform.shared)
      case ObjectFilter.xvtrs:             XvtrView(viewModel: viewModel)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct GuiClientView_Previews: PreviewProvider {
  static var previews: some View {
    GuiClientView( store:
                    Store(initialState: ApiModule.State(),
                          reducer: ApiModule()),
                   packetModel: PacketModel.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
