//
//  ObjectsView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import SwiftUI
import ComposableArchitecture

// ----------------------------------------------------------------------------
// MARK: - View

struct ObjectsView: View {
  let store: Store<ApiState, ApiAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      ScrollView([.horizontal, .vertical]) {
        VStack(alignment: .leading) {
          if viewStore.radio == nil {
            Text("Radio objects will be displayed here")
          } else {
            RadioView(store: store)
            GuiClientsView(store: store)
            if viewStore.isGui == false { NonGuiClientView(store: store) }
          }
        }
      }
      .font(.system(size: viewStore.fontSize, weight: .regular, design: .monospaced))
      .frame(minWidth: 400, maxWidth: .infinity, alignment: .topLeading)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000
import TcpCommands
import UdpStreams
import Shared

struct ObjectsView_Previews: PreviewProvider {

  static var previews: some View {
    ObjectsView(
      store: Store(
        initialState: ApiState(
          isGui: false,
          radio: Radio(testPacket,
                       connectionType: .nonGui,
                       command: Tcp(),
                       stream: Udp())
        ),
        reducer: apiReducer,
        environment: ApiEnvironment()
      )
    )
      .frame(minWidth: 975)
      .padding()
      .previewDisplayName("----- Non Gui -----")

    ObjectsView(
      store: Store(
        initialState: ApiState(
          isGui: true,
          radio: Radio(testPacket,
                       connectionType: .gui,
                       command: Tcp(),
                       stream: Udp())
        ),
        reducer: apiReducer,
        environment: ApiEnvironment()
      )
    )
      .frame(minWidth: 975)
      .padding()
      .previewDisplayName("----- Gui -----")
  }
}
