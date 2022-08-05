//
//  ObjectsView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import SwiftUI
import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct ObjectsView: View {
  @ObservedObject var apiModel: ApiModel
  @ObservedObject var api6000: Model

//  @StateObject var model = Model.shared
  
  var body: some View {
    if apiModel.isConnected == false {
      VStack(alignment: .leading) {
        Spacer()
        Text("Radio objects will be displayed here")
        Spacer()
      }
      .frame(minWidth: 900, maxWidth: .infinity)
      .font(.system(size: apiModel.fontSize, weight: .regular, design: .monospaced))
    }
    else {
//      ScrollViewReader { proxy in
//        ScrollView([.horizontal, .vertical]) {
      VStack(alignment: .leading) {
            RadioView(api6000: api6000)
        if apiModel.isGui == false { NonGuiClientView(api6000: api6000) }
            GuiClientsView(api6000: api6000, apiModel: apiModel)
//            Spacer()
          }
          .frame(minWidth: 900, maxWidth: .infinity, alignment: .leading)
          .font(.system(size: apiModel.fontSize, weight: .regular, design: .monospaced))
//        }
//      }
      .frame(minWidth: 900)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct ObjectsView_Previews: PreviewProvider {
  
  static var previews: some View {
    ObjectsView(apiModel: ApiModel(), api6000: Model.shared )
      .frame(minWidth: 975)
      .padding()
      .previewDisplayName("----- Non Gui -----")
    
    ObjectsView(apiModel: ApiModel(), api6000: Model.shared )
      .frame(minWidth: 975)
      .padding()
      .previewDisplayName("----- Gui -----")
  }
}
