//
//  MessageView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import SwiftUI

// ----------------------------------------------------------------------------
// MARK: - View

struct MessagesView: View {
  @ObservedObject var model: ApiModel
  
  func chooseColor(_ text: String) -> Color {
    if text.prefix(1) == "C" { return Color(.systemGreen) }                         // Commands
    if text.prefix(1) == "R" && text.contains("|0|") { return Color(.systemGray) }  // Replies no error
    if text.prefix(1) == "R" && !text.contains("|0|") { return Color(.systemRed) }  // Replies w/error
    if text.prefix(2) == "S0" { return Color(.systemOrange) }                       // S0

    return Color(.textColor)
  }
  
  var body: some View {
    
    ScrollView([.horizontal, .vertical]) {
      
      VStack(alignment: .leading) {
        if model.filteredMessages.count == 0 {
          Text("TCP messages will be displayed here")
        } else {
          if model.reverseLog {
            ForEach(model.filteredMessages.reversed(), id: \.id) { message in
              HStack {
                if model.showTimes { Text("\(message.timeInterval)") }
                Text(message.text)
              }
              .foregroundColor( message.color )
            }
          } else {
            ForEach(model.filteredMessages, id: \.id) { message in
              HStack {
                if model.showTimes { Text("\(message.timeInterval)") }
                Text(message.text)
              }
              .foregroundColor( chooseColor(message.text) )
            }
          }
        }
      }
      .font(.system(size: model.fontSize, weight: .regular, design: .monospaced))
      .frame(minWidth: 12000, maxWidth: .infinity, alignment: .leading)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct MessagesView_Previews: PreviewProvider {
  static var previews: some View {
    MessagesView(model: ApiModel() )
      .frame(minWidth: 975)
      .padding()
  }
}
