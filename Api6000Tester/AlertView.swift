//
//  AlertView.swift
//  Api6000TesterX
//
//  Created by Douglas Adams on 7/30/22.
//

import SwiftUI

struct AlertView: View {
  let model: AlertModel
  
  var body: some View {
    VStack(alignment: .center) {
      Text(model.title).font(.title).foregroundColor(.red)
      Divider()
      Spacer()
      if model.message != nil { Text(model.message! ) }
      Spacer()
      Divider()
      Button(model.text == nil ? "Ok" : model.text!) { model.action() }
    }
    .frame(height: 150)
    .padding()
  }
}

struct AlertView_Previews: PreviewProvider {
  static var previews: some View {
    AlertView(model: AlertModel(title: "Test", message: "An ERROR was logged", action: {} ))
  }
}
