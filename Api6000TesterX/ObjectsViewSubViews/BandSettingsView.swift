//
//  BandSettingsView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI

// ----------------------------------------------------------------------------
// MARK: - View

struct BandSettingsView: View {
  @ObservedObject var model: Model
  
  var body: some View {
    
    HStack(spacing: 20) {
      Text("BANDSETTINGS -> ").frame(width: 140, alignment: .leading)
      Text("BANDSETTINGS NOT IMPLEMENTED")
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000


import Shared

struct BandSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    BandSettingsView(model: Model.shared)
    .frame(minWidth: 975)
    .padding()
  }
}
