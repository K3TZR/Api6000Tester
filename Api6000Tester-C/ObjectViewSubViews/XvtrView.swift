//
//  XvtrView.swift
//  Api6000TesterX
//
//  Created by Douglas Adams on 8/5/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct XvtrView: View {
  @ObservedObject var model: Model
  
  var body: some View {
    
    if model.xvtrs.count == 0 {
      HStack(spacing: 5) {
        Text("         XVTRs")
        Text("None present").foregroundColor(.red)
      }
      
    } else {
      HStack(spacing: 10) {
        Text("         XVTR -> ")
        Text("NOT IMPLEMENTED").foregroundColor(.red)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct XvtrView_Previews: PreviewProvider {
  static var previews: some View {
    XvtrView(model: Model.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
