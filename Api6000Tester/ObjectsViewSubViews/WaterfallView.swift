//
//  WaterfallView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/24/22.
//

import SwiftUI

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct WaterfallView: View {
  @ObservedObject var api6000: Model
  let panadapterId: PanadapterId
  
  var body: some View {
    
    if api6000.waterfalls.count == 0 {
      Text("         WATERFALLS -> None present").foregroundColor(.red)
    } else {
      ForEach(Array(api6000.waterfalls)) { waterfall in
        if waterfall.panadapterId == panadapterId {
          HStack(spacing: 20) {
            HStack(spacing: 5) {
              Text("         WATERFALL ")
              Text(waterfall.id.hex).foregroundColor(.secondary)
            }
            HStack(spacing: 5) {
              Text("Streaming")
              Text(waterfall.isStreaming ? "Y" : "N").foregroundColor(waterfall.isStreaming ? .green : .red)
            }

            HStack(spacing: 5) {
              Text("AutoBlack")
              Text(waterfall.autoBlackEnabled ? "Y" : "N").foregroundColor(waterfall.autoBlackEnabled ? .green : .red)
            }
            
            HStack(spacing: 5) {
              Text("ColorGain")
              Text("\(waterfall.colorGain)").foregroundColor(.secondary)
            }
            
            HStack(spacing: 5) {
              Text("BlackLevel")
              Text("\(waterfall.blackLevel)").foregroundColor(.secondary)
            }
            
            HStack(spacing: 5) {
              Text("Duration")
              Text("\(waterfall.lineDuration)").foregroundColor(.secondary)
            }
          }
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct WaterfallView_Previews: PreviewProvider {
  static var previews: some View {
    WaterfallView(api6000: Model.shared, panadapterId: 1)
      .frame(minWidth: 1000)
      .padding()
  }
}
