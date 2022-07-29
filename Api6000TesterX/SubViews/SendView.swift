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
  @ObservedObject var apiModel: ApiModel
  
  @State var someText = ""
  
  var body: some View {
    
    HStack(spacing: 25) {
      Group {
        Button("Send") { apiModel.sendButton() }
          .keyboardShortcut(.defaultAction)
        
        HStack(spacing: 0) {
          Image(systemName: "x.circle").foregroundColor(apiModel.isConnected == false ? .gray : nil)
            .onTapGesture { apiModel.commandToSend = "" }
            .disabled(apiModel.isConnected == false)
          TextField("Command to send", text: $apiModel.commandToSend)
        }
      }
      .disabled(apiModel.isConnected == false)
      
      Spacer()
      Toggle("Clear on Send", isOn: $apiModel.clearOnSend)
    }
    
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct SendView_Previews: PreviewProvider {
  static var previews: some View {
    SendView(apiModel: ApiModel() )
      .frame(minWidth: 975)
      .padding()
  }
}
