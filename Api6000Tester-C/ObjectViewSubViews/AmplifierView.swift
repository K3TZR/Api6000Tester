//
//  SwiftUIView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/24/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct AmplifierView: View {
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    if viewModel.amplifiers.count == 0 {
      HStack(spacing: 5) {
        Text("AMPLIFIERs")
        Text("None present").foregroundColor(.red)
      }
      .padding(.leading, 40)
      
    } else {
      ForEach(viewModel.amplifiers) { amplifier in
        DetailView(amplifier: amplifier)
      }
      .padding(.leading, 40)
    }
  }
}

private struct DetailView: View {
  @ObservedObject var amplifier: Amplifier
  
  var body: some View {
    HStack(spacing: 20) {
      Text("AMPLIFIER")
      Text(amplifier.id.hex)
      Text(amplifier.model)
      Text(amplifier.ip)
      Text("Port \(amplifier.port)")
      Text(amplifier.state)
    }
    .padding(.leading, 40)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000


import Shared

struct AmplifierView_Previews: PreviewProvider {
  static var previews: some View {
    AmplifierView(viewModel: ViewModel.shared)
      .frame(minWidth: 975)
      .padding()
  }
}
