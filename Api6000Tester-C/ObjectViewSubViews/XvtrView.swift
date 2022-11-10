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
  
  var body: some View {
    
    if viewModel.xvtrs.count == 0 {
      HStack(spacing: 20) {
        Text("XVTRs").frame(width: 80, alignment: .leading)
        Text("None present").foregroundColor(.red)
      }
      .padding(.leading, 40)
      
    } else {
      HStack(spacing: 20) {
        Text("XVTR").frame(width: 80, alignment: .leading)
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
