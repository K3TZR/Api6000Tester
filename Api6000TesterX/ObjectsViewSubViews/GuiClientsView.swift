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
        StreamView(model: model)
        TnfView(model: model)
        PanadapterView(model: model, handle: handle, showMeters: true)

      case ObjectFilter.coreNoMeters.rawValue:
        StreamView(model: model)
        PanadapterView(model: model, handle: handle, showMeters: false)

//      case .amplifiers:       AmplifierView(store: store)
//      case .bandSettings:     BandSettingsView(store: store)
//      case .interlock:        InterlockView(store: store)
//      case .memories:         MemoriesView(store: store)
//      case .meters:           MeterView(store: store, sliceId: nil)
//      case .streams:          StreamView(store: store)
//      case .transmit:         TransmitView(store: store)
      case ObjectFilter.tnfs.rawValue:    TnfView(model: model)
//      case .waveforms:        WaveformView(store: store)
//      case .xvtrs:            XvtrView(store: store)
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
