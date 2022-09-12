//
//  WaveformView.swift
//  Api6000TesterX
//
//  Created by Douglas Adams on 8/4/22.
//

import SwiftUI
import Api6000

struct WaveformView: View {
  @ObservedObject var model: Model
  
  var body: some View {
    
    if model.waveform.waveformList.isEmpty {
      HStack(spacing: 5) {
        Text("        WAVEFORMs")
        Text("None present").foregroundColor(.red)
      }
      
    } else {
      HStack(spacing: 10) {
        Text("        WAVEFORMS -> ")
        Text(model.waveform.waveformList)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct WaveformView_Previews: PreviewProvider {
  static var previews: some View {
    WaveformView(model: Model.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
