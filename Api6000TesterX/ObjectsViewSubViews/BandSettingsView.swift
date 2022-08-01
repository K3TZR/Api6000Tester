//
//  BandSettingsView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct BandSettingsView: View {
  @EnvironmentObject var model: Model
  
  var body: some View {
    
    HStack(spacing: 20) {
      Text("BANDSETTINGS -> ")
      Text("NOT IMPLEMENTED").foregroundColor(.red)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct BandSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    BandSettingsView()
    .frame(minWidth: 975)
    .padding()
  }
}
