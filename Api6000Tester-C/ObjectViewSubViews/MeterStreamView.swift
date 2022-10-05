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
  
  let pre = String(repeating: " ", count: 6)
  let post = String(repeating: " ", count: 3)

  var body: some View {
    
    // MeterStream
    HStack(spacing: 20) {
      HStack(spacing: 0) {
        Text(pre + "METERS" + post)
        Text("Id")
        Text(Meter.isStreaming ? Meter.streamId!.hex : "0x--------").padding(.leading, 5).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Streaming")
        Text(Meter.isStreaming ? "Y" : "N").foregroundColor(Meter.isStreaming ? .green : .red)
      }
    }
  }
}

struct MeterStreamView_Previews: PreviewProvider {
  static var previews: some View {
    MeterStreamView( viewModel: ViewModel.shared )
  }
}
