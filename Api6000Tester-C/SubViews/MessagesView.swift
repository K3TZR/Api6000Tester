//
//  MessageView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 1/8/22.
//

import SwiftUI
import ComposableArchitecture

// ----------------------------------------------------------------------------
// MARK: - View

struct MessagesView: View {
  let store: Store<ApiState, ApiAction>
  
  func chooseColor(_ text: String) -> Color {
    if text.prefix(1) == "C" { return Color(.systemGreen) }                         // Commands
    if text.prefix(1) == "R" && text.contains("|0|") { return Color(.systemGray) }  // Replies no error
    if text.prefix(1) == "R" && !text.contains("|0|") { return Color(.systemRed) }  // Replies w/error
    if text.prefix(2) == "S0" { return Color(.systemOrange) }                       // S0
    
    return Color(.textColor)
  }

//  func formatTime(_ date: Date) -> String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
//
//    return formatter.string(from: date)
//
//  }
  
  var body: some View {
    
    WithViewStore(store) { viewStore in
      ScrollViewReader { proxy in
        ScrollView([.horizontal, .vertical]) {
          
          VStack {
            
            if viewStore.filteredMessages.count == 0 {
              VStack {
                Text("TCP messages will be displayed here")
                Text("(in reverse order of receipt)")
              }
              
            } else {
              ForEach(viewStore.filteredMessages.reversed(), id: \.id) { message in
                HStack {
                  if viewStore.showTimes { Text("\(message.timeInterval ?? 0)") }
                  Text(message.text)
                }
                .tag(message.id)
                .foregroundColor( chooseColor(message.text) )
              }
              .frame(minWidth: 900, maxWidth: .infinity, alignment: .leading)
              
              .onChange(of: viewStore.gotoFirst, perform: { _ in
                let id = viewStore.gotoFirst ? viewStore.filteredMessages.first!.id : viewStore.filteredMessages.last!.id
                proxy.scrollTo(id, anchor: .topLeading)
              })
              .onChange(of: viewStore.filteredMessages.count, perform: { _ in
                let id = viewStore.gotoFirst ? viewStore.filteredMessages.first!.id : viewStore.filteredMessages.last!.id
                proxy.scrollTo(id, anchor: .bottomLeading)
              })
            }
          }
          .frame(minWidth: 900, maxWidth: .infinity)
          .font(.system(size: viewStore.fontSize, weight: .regular, design: .monospaced))
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct MessagesView_Previews: PreviewProvider {
  static var previews: some View {
    MessagesView(
      store: Store(
        initialState: ApiState(),
        reducer: apiReducer,
        environment: ApiEnvironment()
      )
    )
      .frame(minWidth: 975)
      .padding()
  }
}
