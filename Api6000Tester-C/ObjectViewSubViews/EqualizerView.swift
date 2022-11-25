//
//  EqualizerView.swift
//  Api6000Tester
//
//  Created by Douglas Adams on 8/8/22.
//

import SwiftUI

import ApiModel
import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct EqualizerView: View {
  @ObservedObject var apiModel: ApiModel
  
  var body: some View {
    VStack(alignment: .leading) {
      HeadingView()
      ForEach(apiModel.equalizers) { eq in
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
        Text(String(format: "%+2.0f", eq.hz63))
        Text(String(format: "%+2.0f", eq.hz125))
        Text(String(format: "%+2.0f", eq.hz250))
        Text(String(format: "%+2.0f", eq.hz500))
        Text(String(format: "%+2.0f", eq.hz1000))
        Text(String(format: "%+2.0f", eq.hz2000))
        Text(String(format: "%+2.0f", eq.hz4000))
        Text(String(format: "%+2.0f", eq.hz8000))
      }.frame(width: 60)
    }
    .foregroundColor(.secondary)
  }
}



// ----------------------------------------------------------------------------
// MARK: - Preview

struct EqualizerView_Previews: PreviewProvider {
  static var previews: some View {
    EqualizerView(apiModel: ApiModel.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
