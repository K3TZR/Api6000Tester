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
  
  let post = String(repeating: " ", count: 8)
  
  var body: some View {
    
    if gps.installed {
      HStack(spacing: 20) {
        Text("GPS").frame(width: 80, alignment: .leading)
        Text("NOT IMPLEMENTED").foregroundColor(.red)
      }
      .padding(.leading, 40)

    } else {
      HStack(spacing: 20) {
        Text("GPS").frame(width: 80, alignment: .leading)
        Text("NOT INSTALLED").foregroundColor(.red)
      }
      .padding(.leading, 40)
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
