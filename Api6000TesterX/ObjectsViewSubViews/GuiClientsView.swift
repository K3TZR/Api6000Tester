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

struct GuiClientsView: View {
  @EnvironmentObject var model: Model
  let apiModel: ApiModel
  
  var body: some View {
    if model.activePacketId == nil {
      EmptyView()
    } else {
      ForEach(model.guiClients, id: \.id) { guiClient in
        Divider().background(Color(.red))
        HStack(spacing: 20) {
          Text("GUI CLIENT -> ").frame(width: 140, alignment: .leading)
          Text("\(guiClient.station)     \(guiClient.program)").frame(width: 220, alignment: .leading)
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
            Text(guiClient.isLocalPtt ? "Y" : "N")
              .foregroundColor(guiClient.isLocalPtt ? .green : .red)
          }
        }
        GuiClientSubView(handle: guiClient.handle, apiModel: apiModel)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

struct GuiClientSubView: View {
  @EnvironmentObject var model: Model
  let handle: Handle
  let apiModel: ApiModel
  
  var body: some View {
    
    switch apiModel.objectFilter {
      
    case ObjectFilter.core.rawValue:
      StreamView(handle: handle).environmentObject(model)
      TnfView()
      PanadapterView(handle: handle, showMeters: true)
      
    case ObjectFilter.coreNoMeters.rawValue:
      StreamView(handle: handle)
      PanadapterView(handle: handle, showMeters: false)
      
      //      case ObjectFilter.amplifiers.rawValue:       AmplifierView()
    case ObjectFilter.bandSettings.rawValue:     BandSettingsView()
      //      case ObjectFilter.interlock.rawValue:        InterlockView()
      //      case ObjectFilter.memories.rawValue:         MemoriesView()
    case ObjectFilter.meters.rawValue:          MeterView(sliceId: nil)
    case ObjectFilter.streams.rawValue:          StreamView(handle: handle)
      //      case ObjectFilter.transmit.rawValue:         TransmitView()
    case ObjectFilter.tnfs.rawValue:            TnfView()
      //      case ObjectFilter.waveforms.rawValue:        WaveformView()
      //      case ObjectFilter.xvtrs.rawValue:            XvtrView()
    default:    EmptyView()
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct GuiClientsView_Previews: PreviewProvider {
  static var previews: some View {
    GuiClientsView( apiModel: ApiModel() )
      .frame(minWidth: 975)
      .padding()
  }
}
