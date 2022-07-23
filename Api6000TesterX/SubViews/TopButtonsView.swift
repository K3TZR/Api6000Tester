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
  @ObservedObject var model: ApiModel
  
  public  var body: some View {
    
    HStack(spacing: 30) {
      Button(model.isConnected ? "Stop" : "Start") { model.startStopButton() }
        .keyboardShortcut(model.isConnected ? .cancelAction : .defaultAction)
      
      HStack(spacing: 20) {
        Toggle("Gui", isOn: $model.isGui)
          .disabled(model.isConnected )
        Toggle("Times", isOn: $model.showTimes)
        Toggle("Pings", isOn: $model.showPings)
      }
      
      Spacer()
      Picker("", selection: $model.connectionMode) {
        Text("Local").tag(ConnectionMode.local.rawValue)
        Text("Smartlink").tag(ConnectionMode.smartlink.rawValue)
        Text("Both").tag(ConnectionMode.both.rawValue)
        Text("None").tag(ConnectionMode.none.rawValue)
      }
      .pickerStyle(.segmented)
      .labelsHidden()
      .frame(width: 200)
      
      Spacer()
      Toggle("Force Smartlink Login", isOn: $model.forceWanLogin)
        .disabled(model.connectionMode == ConnectionMode.local.rawValue || model.connectionMode == ConnectionMode.none.rawValue)
      Toggle("Use Default", isOn: $model.useDefault)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct TopButtonsView_Previews: PreviewProvider {
  static var previews: some View {
    TopButtonsView(model: ApiModel())
      .frame(minWidth: 975)
      .padding()
  }
}
