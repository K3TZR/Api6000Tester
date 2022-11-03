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
  let store: StoreOf<ApiModule>
  @ObservedObject var viewModel: ViewModel

  @Dependency(\.packetModel) var packetModel
  
  
  
  
  struct ViewState: Equatable {
    let isGui: Bool
    let fontSize: CGFloat
    init(state: ApiModule.State) {
      self.isGui = state.isGui
      self.fontSize = state.fontSize
    }
  }

  
  
  
  
  
  
  
  var body: some View {
    
    WithViewStore(self.store, observe: ViewState.init ) { viewStore in
      ScrollView([.horizontal, .vertical]) {
        if viewModel.radio == nil {
          VStack(alignment: .center) {
            Text("Radio objects will be displayed here")
          }
          .frame(minWidth: 900, maxWidth: .infinity, alignment: .center)
          
        } else {
          VStack(alignment: .leading) {
            if viewModel.activePacket == nil {
              EmptyView()
            } else {
              RadioView(viewModel: viewModel)
              GuiClientView(store: store, packetModel: packetModel)
              if viewStore.isGui == false { TesterView(viewModel: viewModel) }
            }
          }
        }
      }
      .frame(minWidth: 900, maxWidth: .infinity, alignment: .leading)
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
        initialState: ApiModule.State(isGui: false),
        reducer: ApiModule()
      ),
      viewModel: ViewModel.shared
    )
      .frame(minWidth: 975)
      .padding()
  }
}
