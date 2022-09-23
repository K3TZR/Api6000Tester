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
  @ObservedObject var model: Model
  
  var body: some View {
    
    // MeterStream
    HStack(spacing: 20) {
      HStack(spacing: 5) {
        Text("        METERS     Stream").foregroundColor(.blue)
        Text(Meter.isStreaming ? Meter.streamId!.hex : "0x--------").foregroundColor(.secondary)
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
    MeterStreamView( model: Model.shared )
  }
}
