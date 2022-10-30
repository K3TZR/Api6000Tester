//
//  BottomButtonsView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import ComposableArchitecture
import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct BottomButtonsView: View {
  let store: StoreOf<ApiModule>
  
  @Dependency(\.messagesModel) var messagesModel
  
  var body: some View {

    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack {
        Stepper("Font Size",
                value: viewStore.binding(
                  get: \.fontSize,
                  send: { value in .fontSizeStepper(value) }),
                in: 8...14)
        Text(String(format: "%2.0f", viewStore.fontSize)).frame(alignment: .leading)
        
        Spacer()
        
        HStack {
          Text(viewStore.gotoFirst ? "Goto Last" : "Goto First")
          Image(systemName: viewStore.gotoFirst ? "arrow.up.square" : "arrow.down.square").font(.title)
            .onTapGesture { viewStore.send(.toggle(\.gotoFirst)) }
            .disabled(messagesModel.filteredMessages.count == 0)
        }
        .frame(width: 120, alignment: .trailing)

        Spacer()
        
        HStack {
          Button("Save") { viewStore.send(.saveButton) }
        }
        Spacer()
        
        HStack(spacing: 40) {
          Toggle("Clear on Start", isOn: viewStore.binding(get: \.clearOnStart, send: .toggle(\.clearOnStart)))
          Toggle("Clear on Stop", isOn: viewStore.binding(get: \.clearOnStop, send: .toggle(\.clearOnStop)))
          Button("Clear Now") { viewStore.send(.clearNowButton)}
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct BottomButtonsView_Previews: PreviewProvider {
  static var previews: some View {
    BottomButtonsView(
      store: Store(
        initialState: ApiModule.State(),
        reducer: ApiModule()
      )
    )
      .frame(minWidth: 975)
      .padding()
  }
}
