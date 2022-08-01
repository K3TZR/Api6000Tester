//
//  TopButtonsView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import SwiftUI

// ----------------------------------------------------------------------------
// MARK: - View

public struct TopButtonsView: View {
  @ObservedObject var apiModel: ApiModel
  
  public  var body: some View {
    
    HStack(spacing: 30) {
      Button(apiModel.isConnected ? "Stop" : "Start") { apiModel.startStopButton() }
        .keyboardShortcut(apiModel.isConnected ? .cancelAction : .defaultAction)
      
      HStack(spacing: 20) {
        Toggle("Gui", isOn: $apiModel.isGui)
          .disabled(apiModel.isConnected )
        Toggle("Times", isOn: $apiModel.showTimes)
        Toggle("Pings", isOn: $apiModel.showPings)
      }
      
      Spacer()
      Picker("", selection: $apiModel.connectionMode) {
        Text("Local").tag(ConnectionMode.local.rawValue)
        Text("Smartlink").tag(ConnectionMode.smartlink.rawValue)
        Text("Both").tag(ConnectionMode.both.rawValue)
        Text("None").tag(ConnectionMode.none.rawValue)
      }
      .pickerStyle(.segmented)
      .labelsHidden()
      .frame(width: 200)
      
      Spacer()
      Toggle("Force Smartlink Login", isOn: $apiModel.forceSmartlinkLogin)
        .disabled(apiModel.connectionMode == ConnectionMode.local.rawValue || apiModel.connectionMode == ConnectionMode.none.rawValue)
      Toggle("Use Default", isOn: $apiModel.useDefault)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct TopButtonsView_Previews: PreviewProvider {
  static var previews: some View {
    TopButtonsView(apiModel: ApiModel())
      .frame(minWidth: 975)
      .padding()
  }
}
