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
  @ObservedObject var model: Model = Model.shared
  let apiModel: ApiModel
  
  var body: some View {
    if model.activePacketId == nil {
      EmptyView()
    } else {
      ForEach(model.guiClients, id: \.id) { guiClient in
        Divider().background(Color(.red))
        HStack(spacing: 20) {
          Text("GUI CLIENT -> ").frame(width: 140, alignment: .leading)
          Text("\(guiClient.program) / \(guiClient.station)").frame(width: 220, alignment: .leading)
          Text("Handle \(guiClient.handle.hex)")
          Text("ClientId \(guiClient.clientId ?? "Unknown")")
          Text("LocalPtt \(guiClient.isLocalPtt ? "Y" : "N")")
        }
        GuiClientSubView(model: model, handle: guiClient.handle, apiModel: apiModel)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

struct GuiClientSubView: View {
  @ObservedObject var model: Model
  let handle: Handle
  let apiModel: ApiModel

  var body: some View {

      switch apiModel.objectFilter {

      case ObjectFilter.core.rawValue:
        StreamView(model: model, handle: handle)
        TnfView(model: model)
        PanadapterView(model: model, handle: handle, showMeters: true)

      case ObjectFilter.coreNoMeters.rawValue:
        StreamView(model: model, handle: handle)
        PanadapterView(model: model, handle: handle, showMeters: false)

//      case ObjectFilter.amplifiers.rawValue:       AmplifierView(model: model)
      case ObjectFilter.bandSettings.rawValue:     BandSettingsView(model: model)
//      case ObjectFilter.interlock.rawValue:        InterlockView(model: model)
//      case ObjectFilter.memories.rawValue:         MemoriesView(model: model)
      case ObjectFilter.meters.rawValue:          MeterView(model: model, sliceId: nil)
      case ObjectFilter.streams.rawValue:          StreamView(model: model, handle: handle)
//      case ObjectFilter.transmit.rawValue:         TransmitView(model: model)
      case ObjectFilter.tnfs.rawValue:            TnfView(model: model)
//      case ObjectFilter.waveforms.rawValue:        WaveformView(model: model)
//      case ObjectFilter.xvtrs.rawValue:            XvtrView(model: model)
      default:    EmptyView()
      }
    }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct GuiClientsView_Previews: PreviewProvider {
  static var previews: some View {
    GuiClientsView( model: Model.shared , apiModel: ApiModel() )
    .frame(minWidth: 975)
    .padding()
  }
}
