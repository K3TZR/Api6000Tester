//
//  ObjectsView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import ComposableArchitecture
import SwiftUI

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct ObjectsView: View {
  let store: Store<ApiState, ApiAction>
  @ObservedObject var packets: Packets
  @ObservedObject var viewModel: ViewModel
  @ObservedObject var streamModel: StreamModel

  
//  @State var users = [
//    User(id: 1, name: "Taylor Swift", score: 90, other: 200),
//    User(id: 2, name: "Justin Bieber", score: 80, other: 300),
//    User(id: 3, name: "Adele Adkins", score: 85, other: 400)
//  ]

  var body: some View {
    WithViewStore(self.store) { viewStore in
      ScrollView([.horizontal, .vertical]) {
        VStack(alignment: .leading) {
          if viewModel.radio == nil {
            Text("Radio objects will be displayed here")
          } else {
            RadioView(store: store, viewModel: viewModel)
            GuiClientView(store: store, packets: packets, viewModel: viewModel, streamModel: streamModel)
            if viewStore.isGui == false { NonGuiClientView(viewModel: viewModel) }
          }
        }
        .frame(minWidth: 400, maxWidth: .infinity, alignment: .leading)
      }
      .frame(minWidth: 400, maxWidth: .infinity, alignment: .topLeading)
      .font(.system(size: viewStore.fontSize, weight: .regular, design: .monospaced))
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct ObjectsView_Previews: PreviewProvider {

  static var previews: some View {
    ObjectsView(
      store: Store(
        initialState: ApiState(isGui: false),
        reducer: apiReducer,
        environment: ApiEnvironment()
      ),
      packets: Packets.shared,
      viewModel: ViewModel.shared,
      streamModel: StreamModel.shared
    )
      .frame(minWidth: 975)
      .padding()
  }
}
