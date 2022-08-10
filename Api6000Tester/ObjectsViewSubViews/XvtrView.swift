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
  @ObservedObject var api6000: Model
  
  var body: some View {
    
    if api6000.xvtrs.count == 0 {
      Text("         XVTRs -> None present").foregroundColor(.red)
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
    XvtrView(api6000: Model.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
