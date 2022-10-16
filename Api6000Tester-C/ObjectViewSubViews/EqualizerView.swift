//
//  EqualizerView.swift
//  Api6000Tester
//
//  Created by Douglas Adams on 8/8/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct EqualizerView: View {
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    VStack(alignment: .leading) {
      HeadingView()
      ForEach(viewModel.equalizers) { eq in
        DetailView(eq: eq)
      }
    }
    .padding(.leading, 40)
  }
}

private struct HeadingView: View {
  
  var body: some View {
    HStack(spacing: 10) {
      Text("EQUALIZER").frame(width: 80, alignment: .leading)
      Group {
        Text("Enabled")
        Text("63 Hz")
        Text("125 Hz")
        Text("250 Hz")
        Text("500 Hz")
        Text("1000 Hz")
        Text("2000 Hz")
        Text("4000 Hz")
        Text("8000 Hz")
      }.frame(width: 60)
    }
    Text("")
  }
}

private struct DetailView: View {
  @ObservedObject var eq: Equalizer
  
  var body: some View {
    HStack(spacing: 10) {
      Text(eq.id).foregroundColor(.green).frame(width: 80, alignment: .leading)
      Group {
        Text(eq.eqEnabled ? "Y" : "N").foregroundColor(eq.eqEnabled ? .green : .red)
        Text(String(format: "%+2.0f", eq.level63Hz))
        Text(String(format: "%+2.0f", eq.level125Hz))
        Text(String(format: "%+2.0f", eq.level250Hz))
        Text(String(format: "%+2.0f", eq.level500Hz))
        Text(String(format: "%+2.0f", eq.level1000Hz))
        Text(String(format: "%+2.0f", eq.level2000Hz))
        Text(String(format: "%+2.0f", eq.level4000Hz))
        Text(String(format: "%+2.0f", eq.level8000Hz))
      }.frame(width: 60)
    }
    .foregroundColor(.secondary)
  }
}



// ----------------------------------------------------------------------------
// MARK: - Preview

struct EqualizerView_Previews: PreviewProvider {
  static var previews: some View {
    EqualizerView(viewModel: ViewModel.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
