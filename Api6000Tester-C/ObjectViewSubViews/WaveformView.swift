//
//  WaveformView.swift
//  Api6000TesterX
//
//  Created by Douglas Adams on 8/4/22.
//

import SwiftUI

import Api6000

struct WaveformView: View {
  @ObservedObject var waveform: Waveform
  
  let post = String(repeating: " ", count: 2)

  var body: some View {
    
    if waveform.waveformList.isEmpty {
      HStack(spacing: 0) {
        Text("WAVEFORMs" + post)
        Text("None present").foregroundColor(.red)
      }
      .padding(.leading, 40)
      
    } else {
      HStack(spacing: 10) {
        Text("WAVEFORMS" + post)
        Text(waveform.waveformList)
      }
      .padding(.leading, 40)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct WaveformView_Previews: PreviewProvider {
  static var previews: some View {
    WaveformView(waveform: Waveform.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
