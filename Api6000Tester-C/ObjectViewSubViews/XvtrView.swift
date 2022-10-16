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
  @ObservedObject var viewModel: ViewModel
  
  let post = String(repeating: " ", count: 6)

  var body: some View {
    
    if viewModel.xvtrs.count == 0 {
      HStack(spacing: 0) {
        Text("XVTRs" + post)
        Text("None present").foregroundColor(.red)
      }
      .padding(.leading, 40)
      
    } else {
      HStack(spacing: 10) {
        Text("XVTR " + post)
        Text("NOT IMPLEMENTED").foregroundColor(.red)
      }
      .padding(.leading, 40)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct XvtrView_Previews: PreviewProvider {
  static var previews: some View {
    XvtrView(viewModel: ViewModel.shared)
    .frame(minWidth: 1000)
    .padding()
  }
}
