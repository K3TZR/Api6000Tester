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
  @ObservedObject var model: Model
  let panadapterId: PanadapterId
  
  var body: some View {
    
    ForEach(Array(model.waterfalls)) { waterfall in
      if waterfall.panadapterId == panadapterId {
        HStack(spacing: 20) {
          Text("Waterfall").frame(width: 100, alignment: .trailing)
          Text(waterfall.id.hex)
          Text("AutoBlack \(waterfall.autoBlackEnabled ? "Y" : "N")")
          Text("ColorGain \(waterfall.colorGain)")
          Text("BlackLevel \(waterfall.blackLevel)")
          Text("Duration \(waterfall.lineDuration)")
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct WaterfallView_Previews: PreviewProvider {
  static var previews: some View {
    WaterfallView(
      model: Model.shared,
      panadapterId: 1
    )
    .frame(minWidth: 975)
    .padding()
  }
}
