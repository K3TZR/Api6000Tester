//
//  BottomButtonsView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import SwiftUI
import ComposableArchitecture

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct BottomButtonsView: View {
  let store: Store<ApiState, ApiAction>

  @State var fontSize: CGFloat = 12

  var body: some View {

    WithViewStore(self.store) { viewStore in
      HStack {
        Stepper("Font Size",
                value: viewStore.binding(
                  get: \.fontSize,
                  send: { value in .fontSizeStepper(value) }),
                in: 8...14)
        Text(String(format: "%2.0f", viewStore.fontSize)).frame(alignment: .leading)
        
        Spacer()
        
        HStack {
          Text(viewStore.gotoTop ? "Goto Bottom" : "Goto Top")
          Image(systemName: viewStore.gotoTop ? "arrow.down.square" : "arrow.up.square").font(.title)
            .onTapGesture { viewStore.send(.toggle(\.gotoTop)) }
        }
        .frame(width: 120, alignment: .trailing)

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
        initialState: ApiState(),
        reducer: apiReducer,
        environment: ApiEnvironment()
      )
    )
      .frame(minWidth: 975)
      .padding()
  }
}
