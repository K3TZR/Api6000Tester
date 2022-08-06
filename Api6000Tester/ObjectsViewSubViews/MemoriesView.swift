//
//  MemoriesView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

// ----------------------------------------------------------------------------
// MARK: - View

import SwiftUI

import Api6000

struct MemoriesView: View {
  @ObservedObject var api6000: Model
  
  var body: some View {
    
    if api6000.memories.count == 0 {
      Text("         MEMORIES -> None present").foregroundColor(.red)
    } else {
      HStack(spacing: 10) {
        Text("         MEMORIES -> ")
        Text("NOT IMPLEMENTED").foregroundColor(.red)
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview
struct MemoriesView_Previews: PreviewProvider {
  static var previews: some View {
    MemoriesView(api6000: Model.shared)
    .frame(minWidth: 975)
    .padding()
  }
}
