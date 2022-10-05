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
  @ObservedObject var gps: Gps
  
  let pre = String(repeating: " ", count: 6)
  let post = String(repeating: " ", count: 6)

  var body: some View {
    
    HStack(spacing: 20) {
      if gps.isPresent {
        Text(pre + "GPS" + post + "NOT IMPLEMENTED").foregroundColor(.red)
      } else {
        Text(pre + "GPS" + post + "NOT Installed").foregroundColor(.red)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct GpsView_Previews: PreviewProvider {
  static var previews: some View {
    GpsView(gps: Gps.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
