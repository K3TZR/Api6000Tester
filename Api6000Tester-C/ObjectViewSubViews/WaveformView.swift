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
  
  var body: some View {
    
    if waveform.waveformList.isEmpty {
      HStack(spacing: 20) {
        Text("WAVEFORMs").frame(width: 80, alignment: .leading)
        Text("None present").foregroundColor(.red)
      }
      .padding(.leading, 40)
      
    } else {
      HStack(spacing: 20) {
        Text("WAVEFORMS").frame(width: 80, alignment: .leading)
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
