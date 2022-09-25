//
//  ObjectsView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import SwiftUI
import ComposableArchitecture

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct ObjectsView: View {
  let store: Store<ApiState, ApiAction>
  @ObservedObject var packets: Packets
  @ObservedObject var viewModel: ViewModel
  @ObservedObject var streamModel: StreamModel
  
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
