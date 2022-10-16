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

struct TesterView: View {
  @ObservedObject var viewModel: ViewModel
    
  var body: some View {
    if viewModel.radio != nil {
      VStack(alignment: .leading) {
        Divider().background(Color(.red))
        HStack(spacing: 10) {
          
          HStack {
            Text("NonGui").foregroundColor(.green)
              .font(.title)
            Text("Api6000Tester").foregroundColor(.green)
          }

          HStack(spacing: 5) {
            Text("Bound_to_Station")
            Text("\(viewModel.activeStation ?? "none")").foregroundColor(.secondary)
          }
          if viewModel.radio != nil { TesterRadioViewView(radio: viewModel.radio!) }
        }
      }
    }
  }
}

struct TesterRadioViewView: View {
  @ObservedObject var radio: Radio
  
  var body: some View {
    HStack(spacing: 10) {
      
      HStack(spacing: 5) {
        Text("Handle")
        Text(radio.connectionHandle?.hex ?? "").foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Client_Id")
        Text("\(radio.boundClientId ?? "none")").foregroundColor(.secondary)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct NonGuiClientView_Previews: PreviewProvider {
  static var previews: some View {
    TesterView(viewModel: ViewModel.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
