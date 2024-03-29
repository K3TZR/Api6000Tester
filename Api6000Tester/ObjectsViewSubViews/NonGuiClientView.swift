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
  @ObservedObject var api6000: Model
  
  var body: some View {
    if api6000.radio != nil {
      VStack(alignment: .leading) {
        Divider().background(Color(.red))
        HStack(spacing: 10) {
          
          HStack(spacing: 0) {
            Text("nonGui    ").foregroundColor(.green)
            Text("Handle ")
            Text(api6000.radio!.connectionHandle?.hex ?? "").foregroundColor(.secondary)
          }

          HStack(spacing: 5) {
            Text("Bound_to_Station:")
            Text("\(api6000.activeStation ?? "none")").foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("Client_Id")
            Text("\(api6000.radio!.boundClientId ?? "none")").foregroundColor(.secondary)
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
    NonGuiClientView(api6000: Model.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
