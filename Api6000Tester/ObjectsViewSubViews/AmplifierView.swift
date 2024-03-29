//
//  SwiftUIView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/24/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct AmplifierView: View {
  @ObservedObject var api6000: Model
  
  var body: some View {
    if api6000.amplifiers.count == 0 {
      HStack(spacing: 5) {
        Text("         AMPLIFIERs")
        Text("None present").foregroundColor(.red)
      }
      
    } else {
      ForEach(api6000.amplifiers) { amplifier in
        VStack (alignment: .leading) {
          HStack(spacing: 20) {
            Text("         AMPLIFIER -> ")
            Text(amplifier.id.hex)
            Text(amplifier.model)
            Text(amplifier.ip)
            Text("Port \(amplifier.port)")
            Text(amplifier.state)
          }
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000


import Shared

struct AmplifierView_Previews: PreviewProvider {
  static var previews: some View {
    AmplifierView(api6000: Model.shared)
      .frame(minWidth: 975)
      .padding()
  }
}
