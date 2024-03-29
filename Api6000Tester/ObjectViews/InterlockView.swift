//
//  InterlockView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

// ----------------------------------------------------------------------------
// MARK: - View

import SwiftUI
import ComposableArchitecture

struct InterlockView: View {
  let store: Store<ApiState, ApiAction>
  
  var body: some View {
    
    HStack(spacing: 20) {
      Text("INTERLOCK -> ").frame(width: 140, alignment: .leading)
      Text("INTERLOCK NOT IMPLEMENTED")
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000


import Shared

struct InterlockView_Previews: PreviewProvider {
  static var previews: some View {
    InterlockView(
      store: Store(
        initialState: ApiState(
          radio: Radio(Packet(),
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
  }
}
