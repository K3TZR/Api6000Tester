//
//  SendView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct SendView: View {
  @ObservedObject var model: ApiModel
  
  @State var someText = ""
  
  var body: some View {
    
    HStack(spacing: 25) {
      Group {
        Button("Send") { model.sendButton() }
          .keyboardShortcut(.defaultAction)
        
        HStack(spacing: 0) {
          Image(systemName: "x.circle").foregroundColor(model.isConnected == false ? .gray : nil)
            .onTapGesture { model.commandToSend = "" }
            .disabled(model.isConnected == false)
          TextField("Command to send", text: $model.commandToSend)
        }
      }
      .disabled(model.isConnected == false)
      
      Spacer()
      Toggle("Clear on Send", isOn: $model.clearOnSend)
    }
    
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct SendView_Previews: PreviewProvider {
  static var previews: some View {
    SendView(model: ApiModel() )
      .frame(minWidth: 975)
      .padding()
  }
}
