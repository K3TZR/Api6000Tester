//
//  WaveformView.swift
//  Api6000TesterX
//
//  Created by Douglas Adams on 8/4/22.
//

import SwiftUI
import Api6000

struct WaveformView: View {
  @ObservedObject var api6000: Model
  
  var body: some View {
    
    if api6000.waveform.waveformList.isEmpty {
      Text("         WAVEFORMS -> None present").foregroundColor(.red)
    } else {
      HStack(spacing: 10) {
        Text("         WAVEFORMS -> ")
        Text(api6000.waveform.waveformList)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct WaveformView_Previews: PreviewProvider {
  static var previews: some View {
    WaveformView(api6000: Model.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
