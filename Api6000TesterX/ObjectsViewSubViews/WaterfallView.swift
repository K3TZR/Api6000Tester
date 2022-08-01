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
  @EnvironmentObject var model: Model
  let panadapterId: PanadapterId
  
  var body: some View {
    
    ForEach(Array(model.waterfalls)) { waterfall in
      if waterfall.panadapterId == panadapterId {
        HStack(spacing: 20) {
          Text("Waterfall").frame(width: 100, alignment: .trailing)
          Text(waterfall.id.hex).foregroundColor(.secondary)
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

// ----------------------------------------------------------------------------
// MARK: - Preview

struct WaterfallView_Previews: PreviewProvider {
  static var previews: some View {
    WaterfallView(panadapterId: 1)
      .frame(minWidth: 975)
      .padding()
  }
}
