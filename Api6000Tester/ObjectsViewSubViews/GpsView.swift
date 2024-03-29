//
//  GpsView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct GpsView: View {
  @ObservedObject var api6000: Model
  
  var body: some View {
    
    if let radio = api6000.radio {
      HStack(spacing: 10) {
        Text("          GPS ")
        if radio.gpsPresent {
          Text("NOT IMPLEMENTED").foregroundColor(.red)
        } else {
          Text("NOT Installed").foregroundColor(.red)
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct GpsView_Previews: PreviewProvider {
  static var previews: some View {
    GpsView(api6000: Model.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
