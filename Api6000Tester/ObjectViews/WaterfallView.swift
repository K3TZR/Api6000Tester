//
//  WaterfallView.swift
//  Components6000/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/24/22.
//

import SwiftUI
import ComposableArchitecture

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct WaterfallView: View {
  let store: Store<ApiState, ApiAction>
  let panadapterId: PanadapterId
  
  var body: some View {
    WithViewStore(store.actionless) { viewStore in
      
      ForEach(Array(Model.shared.waterfalls)) { waterfall in
        if waterfall.panadapterId == panadapterId {
          HStack(spacing: 20) {
            Text("Waterfall").frame(width: 100, alignment: .trailing)
            Text(waterfall.id.hex)
            Text("AutoBlack \(waterfall.autoBlackEnabled ? "Y" : "N")")
            Text("ColorGain \(waterfall.colorGain)")
            Text("BlackLevel \(waterfall.blackLevel)")
            Text("Duration \(waterfall.lineDuration)")
          }
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000
import TcpCommands
import UdpStreams
import Shared

struct WaterfallView_Previews: PreviewProvider {
  static var previews: some View {
    WaterfallView(
      store: Store(
        initialState: ApiState(
          radio: Radio(Packet(),
                       connectionType: .gui,
                       command: Tcp(),
                       stream: Udp())
        ),
        reducer: apiReducer,
        environment: ApiEnvironment()
      ),
      panadapterId: 1
    )
    .frame(minWidth: 975)
    .padding()
  }
}
