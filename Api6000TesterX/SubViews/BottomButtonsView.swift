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
  @ObservedObject var apiModel: ApiModel

  var body: some View {
    
    HStack {
      Stepper("Font Size", value: $apiModel.fontSize, in: 8...14)
      Text( String(format: "%2.0f", apiModel.fontSize) ).frame(alignment: .leading)
      Spacer()

      HStack {
        Text(apiModel.gotoTop ? "Goto Bottom" : "Goto Top")
        Image(systemName: apiModel.gotoTop ? "arrow.down.square" : "arrow.up.square").font(.title)
          .onTapGesture { apiModel.gotoTop.toggle() }
      }
//      .disabled(apiModel.isConnected == false)
      .frame(width: 120, alignment: .trailing)
      Spacer()

      HStack(spacing: 40) {
        Toggle("Clear on Start", isOn: $apiModel.clearOnStart)
        Toggle("Clear on Stop", isOn: $apiModel.clearOnStop)
        Button("Clear Now") { apiModel.clearNowButton() }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct BottomButtonsView_Previews: PreviewProvider {
  static var previews: some View {
    BottomButtonsView(apiModel: ApiModel() )
      .frame(minWidth: 975)
      .padding()
  }
}
