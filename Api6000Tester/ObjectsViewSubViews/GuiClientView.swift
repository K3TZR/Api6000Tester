//
//  GuiClientView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct GuiClientView: View {
  @ObservedObject var api6000: Model
  @ObservedObject var apiModel: ApiModel

  var body: some View {
    if api6000.activePacketId == nil {
      EmptyView()
    } else {
      VStack(alignment: .leading) {
        ForEach(api6000.guiClients, id: \.id) { guiClient in
          Divider().background(Color(.red))
          HStack(spacing: 10) {
            Text("GUI   ->")
            HStack(spacing: 5) {
              Text("Station")
              Text("\(guiClient.station)").foregroundColor(.secondary)
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
          GuiClientSubView(handle: guiClient.handle, apiModel: apiModel, api6000: api6000)
        }
      }
      .padding(.bottom, 10)
    }
  }
}

struct GuiClientSubView: View {
  let handle: Handle
  @ObservedObject var apiModel: ApiModel
  @ObservedObject var api6000: Model

  var body: some View {
    
    switch apiModel.objectFilter {
      
    case ObjectFilter.core.rawValue:
//      StreamView(api6000: api6000, handle: handle)
//      TnfView(api6000: api6000)
      PanadapterView(api6000: api6000, handle: handle, showMeters: true)
      
    case ObjectFilter.coreNoMeters.rawValue:
//      StreamView(api6000: api6000, handle: handle)
//      TnfView(api6000: api6000)
      PanadapterView(api6000: api6000, handle: handle, showMeters: false)
      
    case ObjectFilter.amplifiers.rawValue:        AmplifierView(api6000: api6000)
    case ObjectFilter.bandSettings.rawValue:      BandSettingView(api6000: api6000)
    case ObjectFilter.cwx.rawValue:               CwxView(api6000: api6000)
    case ObjectFilter.equalizers.rawValue:        EqualizerView(api6000: api6000)
    case ObjectFilter.interlock.rawValue:         InterlockView(api6000: api6000)
    case ObjectFilter.memories.rawValue:          MemoryView(api6000: api6000)
    case ObjectFilter.meters.rawValue:            MeterView(api6000: api6000, sliceId: nil, sliceClientHandle: nil, handle: handle)
    case ObjectFilter.profiles.rawValue:          ProfileView(api6000: api6000)
    case ObjectFilter.streams.rawValue:           StreamView(api6000: api6000, handle: handle)
    case ObjectFilter.transmit.rawValue:          TransmitView(api6000: api6000)
    case ObjectFilter.tnfs.rawValue:              TnfView(api6000: api6000)
    case ObjectFilter.usbCable.rawValue:          UsbCableView(api6000: api6000)
    case ObjectFilter.wan.rawValue:               WanView(api6000: api6000)
    case ObjectFilter.waveforms.rawValue:         WaveformView(api6000: api6000)
    case ObjectFilter.xvtrs.rawValue:             XvtrView(api6000: api6000)
    default:    EmptyView()
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct GuiClientView_Previews: PreviewProvider {
  static var previews: some View {
    GuiClientView( api6000: Model.shared, apiModel: ApiModel() )
      .frame(minWidth: 1000)
      .padding()
  }
}
