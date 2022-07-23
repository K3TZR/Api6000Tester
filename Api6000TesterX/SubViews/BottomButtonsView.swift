//
//  BottomButtonsView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct BottomButtonsView: View {
  @ObservedObject var model: ApiModel

  var body: some View {
    
    HStack {
      Stepper("Font Size", value: $model.fontSize, in: 8...14)
      Text( String(format: "%2.0f", model.fontSize) ).frame(alignment: .leading)
      Spacer()
      Button("Reverse") { model.reverseButton() }
      Spacer()
      HStack(spacing: 40) {
        Toggle("Clear on Connect", isOn: $model.clearOnConnect)
        Toggle("Clear on Disconnect", isOn: $model.clearOnDisconnect)
        Button("Clear Now") { model.clearNowButton() }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct BottomButtonsView_Previews: PreviewProvider {
  static var previews: some View {
    BottomButtonsView(model: ApiModel() )
      .frame(minWidth: 975)
      .padding()
  }
}
