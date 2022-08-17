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
  @ObservedObject var api6000: Model
  
  var body: some View {
    ForEach(api6000.equalizers) { eq in
      VStack (alignment: .leading) {
        HStack(spacing: 20) {
          
          HStack(spacing: 5) {
            Text("         EQUALIZER")
            Text(eq.id).foregroundColor(.green)
          }
          
          HStack(spacing: 5) {
            Text("Enabled")
            Text(eq.eqEnabled ? "Y" : "N").foregroundColor(eq.eqEnabled ? .green : .red)
          }
          
          HStack(spacing: 5) {
            Text("63_Hz")
            Text(String(format: "%+2.0f", eq.level63Hz))
              .frame(width: 40)
              .foregroundColor(.secondary)
          }

          HStack(spacing: 5) {
            Text("125_Hz")
            Text(String(format: "%+2.0f", eq.level125Hz))
              .frame(width: 40)
              .foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("250_Hz")
            Text(String(format: "%+2.0f", eq.level250Hz))
              .frame(width: 40)
              .foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("500_Hz")
            Text(String(format: "%+2.0f", eq.level500Hz))
              .frame(width: 40)
              .foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("1000_Hz")
            Text(String(format: "%+2.0f", eq.level1000Hz))
              .frame(width: 40)
              .foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("2000_Hz")
            Text(String(format: "%+2.0f", eq.level2000Hz))
              .frame(width: 40)
              .foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("4000_Hz")
            Text(String(format: "%+2.0f", eq.level4000Hz))
              .frame(width: 40)
              .foregroundColor(.secondary)
          }
          
          HStack(spacing: 5) {
            Text("8000_Hz")
            Text(String(format: "%+2.0f", eq.level8000Hz))
              .frame(width: 40)
              .foregroundColor(.secondary)
          }
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct EqualizerView_Previews: PreviewProvider {
  static var previews: some View {
    EqualizerView(api6000: Model.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
