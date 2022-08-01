//
//  NonGuiClientView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/25/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct NonGuiClientView: View {
  @EnvironmentObject var model: Model
  
  var body: some View {
    if model.radio != nil {
      VStack(alignment: .leading) {
        Divider().background(Color(.red))
        HStack(spacing: 20) {
          Text("APITESTER  ->")
          HStack(spacing: 5) {
            Text("Handle")
            Text(model.radio!.connectionHandle?.hex ?? "").foregroundColor(.secondary)
          }
          HStack(spacing: 5) {
            Text("Bound to Station:")
            Text("\(model.activeStation ?? "none")").foregroundColor(.secondary)
          }
          HStack(spacing: 5) {
            Text("Client Id")
            Text("\(model.radio!.boundClientId ?? "none")").foregroundColor(.secondary)
          }
        }
      }
    }
  }
}
                 
// ----------------------------------------------------------------------------
// MARK: - Preview

struct NonGuiClientView_Previews: PreviewProvider {
  static var previews: some View {
    NonGuiClientView()
    .frame(minWidth: 975)
    .padding()
  }
}
