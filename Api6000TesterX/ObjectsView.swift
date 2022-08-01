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
  
  @StateObject var model = Model.shared
  
  var body: some View {
    ScrollView([.horizontal, .vertical]) {
      VStack(alignment: .leading) {
        if apiModel.isConnected == false {
          HStack {
            Text("Radio objects will be displayed here")
          }
          .padding(.trailing, 1400)
        }
        else {
          RadioView()
            .environmentObject(model)
            .padding(.trailing, 1400)
          if apiModel.isGui == false {
            NonGuiClientView()
            .environmentObject(model)
          }
          GuiClientsView(apiModel: apiModel)
            .environmentObject(model)
        }
      }
    }
    .font(.system(size: apiModel.fontSize, weight: .regular, design: .monospaced))
    .frame(minWidth: 400, maxWidth: .infinity, alignment: .topLeading)
  }
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
