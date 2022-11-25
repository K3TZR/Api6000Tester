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
  
  struct ViewState: Equatable {
    let clearOnStart: Bool
    let clearOnStop: Bool
    let fontSize: CGFloat
    let gotoLast: Bool
    let alertOnError: Bool
    init(state: ApiModule.State) {
      self.clearOnStart = state.clearOnStart
      self.clearOnStop = state.clearOnStop
      self.fontSize = state.fontSize
      self.gotoLast = state.gotoLast
      self.alertOnError = state.alertOnError
    }
  }

  var body: some View {

    WithViewStore(self.store, observe: ViewState.init) { viewStore in
      HStack {
        Stepper("Font Size",
                value: viewStore.binding(
                  get: \.fontSize,
                  send: { value in .fontSizeStepper(value) }),
                in: 8...12)
        Text(String(format: "%2.0f", viewStore.fontSize)).frame(alignment: .leading)
        
        Spacer()
        HStack {
          Text("Go to \(viewStore.gotoLast ? "Last" : "First")")
          Image(systemName: viewStore.gotoLast ? "arrow.up.square" : "arrow.down.square").font(.title)
            .onTapGesture { viewStore.send(.toggle(\.gotoLast)) }
        }
        Spacer()
        
        HStack {
          Button("Save") { viewStore.send(.saveButton) }
        }
        Spacer()
        
        HStack(spacing: 40) {
          Toggle("Alert on Error", isOn: viewStore.binding(get: \.alertOnError, send: .toggle(\.alertOnError)))
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
