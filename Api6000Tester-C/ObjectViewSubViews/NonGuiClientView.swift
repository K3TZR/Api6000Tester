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
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    if viewModel.radio != nil {
      VStack(alignment: .leading) {
        Divider().background(Color(.red))
        HStack(spacing: 10) {
          
          Text("Tester    nonGui").foregroundColor(.green).frame(width: 50, alignment: .leading)

          HStack(spacing: 5) {
            Text("Handle")
            Text(viewModel.radio!.connectionHandle?.hex ?? "").foregroundColor(.secondary)
          }

          HStack(spacing: 5) {
            Text("Bound_to_Station")
            Text("\(viewModel.activeStation ?? "none")").foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("Client_Id")
            Text("\(viewModel.radio!.boundClientId ?? "none")").foregroundColor(.secondary)
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
    NonGuiClientView(viewModel: ViewModel.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
