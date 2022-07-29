//
//  ObjectsView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import SwiftUI
import ComposableArchitecture

// ----------------------------------------------------------------------------
// MARK: - View

struct ObjectsView: View {
  @ObservedObject var apiModel: ApiModel
  
  @State var update: Bool = false
  
  var body: some View {
      ScrollView([.horizontal, .vertical]) {
        VStack(alignment: .leading) {
          if apiModel.isConnected == false {
            HStack {
              Text("Radio objects will be displayed here")
            }
            .padding(.trailing, 1400)
//            .border(.red)
          }
          else {
            RadioView()
              .padding(.trailing, 1400)
//              .border(.red)
            GuiClientsView(apiModel: apiModel)
//            if model.isGui == false { NonGuiClientView(model: model) }
          }
        }
      }
      .font(.system(size: apiModel.fontSize, weight: .regular, design: .monospaced))
      .frame(minWidth: 400, maxWidth: .infinity, alignment: .topLeading)
//      .frame(minWidth: 12000, maxWidth: .infinity, alignment: .leading)
    }
//  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

import Api6000

struct ObjectsView_Previews: PreviewProvider {

  static var previews: some View {
    ObjectsView(apiModel: ApiModel() )
      .frame(minWidth: 975)
      .padding()
      .previewDisplayName("----- Non Gui -----")

    ObjectsView(apiModel: ApiModel())
      .frame(minWidth: 975)
      .padding()
      .previewDisplayName("----- Gui -----")
  }
}
