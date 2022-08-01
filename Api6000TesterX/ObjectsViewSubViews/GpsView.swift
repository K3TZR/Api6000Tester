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
  @ObservedObject var model: Model
  
  var body: some View {
    
    HStack(spacing: 20) {
      Text("GPS        ->")
      Text("NOT IMPLEMENTED").foregroundColor(.red)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000


import Shared

struct GpsView_Previews: PreviewProvider {
  static var previews: some View {
    GpsView(model: Model.shared)
    .frame(minWidth: 975)
    .padding()
  }
}
