//
//  MeterStreamView.swift
//  Api6000Tester-C
//
//  Created by Douglas Adams on 9/23/22.
//
import SwiftUI

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct MeterStreamView: View {
  @ObservedObject var viewModel: ViewModel
  
  let post = String(repeating: " ", count: 5)

  var body: some View {
    
    // MeterStream
    HStack(spacing: 20) {
      HStack(spacing: 0) {
        Text("METERS" + post)
        Text("Stream")
        Text(Meter.isStreaming ? Meter.streamId!.hex : "0x--------").padding(.leading, 5).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Streaming")
        Text(Meter.isStreaming ? "Y" : "N").foregroundColor(Meter.isStreaming ? .green : .red)
      }
    }
    .padding(.leading, 40)
  }
}

struct MeterStreamView_Previews: PreviewProvider {
  static var previews: some View {
    MeterStreamView( viewModel: ViewModel.shared )
  }
}
