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
  @ObservedObject var model: Model
  
  var body: some View {
    if model.radio != nil {
      VStack(alignment: .leading) {
        Divider().background(Color(.red))
        HStack(spacing: 10) {
          
          HStack(spacing: 0) {
            Text("nonGui    ").foregroundColor(.green)
            Text("Handle ")
            Text(model.radio!.connectionHandle?.hex ?? "").foregroundColor(.secondary)
          }

          HStack(spacing: 5) {
            Text("Bound_to_Station:")
            Text("\(model.activeStation ?? "none")").foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("Client_Id")
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
    NonGuiClientView(model: Model.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
