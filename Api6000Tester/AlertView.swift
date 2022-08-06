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
      VStack {
        Text(model.title)
        if model.message != nil { Text(model.message! ) }
        if let text = model.buttonText {
          Button(text) { print("-----> Alert Button clicked")}
        }
      }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
      AlertView(model: AlertModel(title: "Test") )
    }
}
