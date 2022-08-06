//
//  MessageView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import SwiftUI
import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct MessagesView: View {
  @ObservedObject var apiModel: ApiModel
  @ObservedObject var api6000: Model

  
  func chooseColor(_ text: String) -> Color {
    if text.prefix(1) == "C" { return Color(.systemGreen) }                         // Commands
    if text.prefix(1) == "R" && text.contains("|0|") { return Color(.systemGray) }  // Replies no error
    if text.prefix(1) == "R" && !text.contains("|0|") { return Color(.systemRed) }  // Replies w/error
    if text.prefix(2) == "S0" { return Color(.systemOrange) }                       // S0
    
    return Color(.textColor)
  }
  
  var body: some View {
    
    ScrollViewReader { proxy in
      ScrollView([.horizontal, .vertical]) {
        
        VStack {
          
          if apiModel.filteredMessages.count == 0 {
            Text("TCP messages will be displayed here")

          } else {
            ForEach(apiModel.filteredMessages, id: \.id) { message in
              HStack {
                if apiModel.showTimes { Text("\(message.timeInterval)") }
                Text(message.text)
              }
              .tag(message.id)
              .foregroundColor( chooseColor(message.text) )
            }
            .frame(minWidth: 900, maxWidth: .infinity, alignment: .leading)

            .onChange(of: apiModel.gotoTop, perform: { _ in
              let id = apiModel.gotoTop ? apiModel.filteredMessages.first!.id : apiModel.filteredMessages.last!.id
              proxy.scrollTo(id, anchor: .topLeading)
            })
            .onChange(of: apiModel.filteredMessages.count, perform: { _ in
              let id = apiModel.gotoTop ? apiModel.filteredMessages.first!.id : apiModel.filteredMessages.last!.id
              proxy.scrollTo(id, anchor: .bottomLeading)
            })
          }
        }
        .frame(minWidth: 900, maxWidth: .infinity)
        .font(.system(size: apiModel.fontSize, weight: .regular, design: .monospaced))
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct MessagesView_Previews: PreviewProvider {
  static var previews: some View {
    MessagesView(apiModel: ApiModel(), api6000: Model.shared )
      .frame(minWidth: 975)
      .padding()
  }
}
