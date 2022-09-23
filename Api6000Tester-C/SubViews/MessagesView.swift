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
  
  @Namespace var topID
  @Namespace var bottomID
  
  func chooseColor(_ text: String) -> Color {
    if text.prefix(1) == "C" { return Color(.systemGreen) }                         // Commands
    if text.prefix(1) == "R" && text.contains("|0|") { return Color(.systemGray) }  // Replies no error
    if text.prefix(1) == "R" && !text.contains("|0|") { return Color(.systemRed) }  // Replies w/error
    if text.prefix(2) == "S0" { return Color(.systemOrange) }                       // S0
    
    return Color(.textColor)
  }

  var body: some View {
    
    WithViewStore(store) { viewStore in
      ZStack {
        if viewStore.filteredMessages.count == 0 { Text("Tcp Messages will be displayed here") }
        ScrollViewReader { proxy in
          ScrollView([.vertical, .horizontal]) {
            VStack(alignment: .leading) {
              Text("Top").hidden()
                .id(topID)
              ForEach(viewStore.filteredMessages.reversed(), id: \.id) { message in
                HStack {
                  if viewStore.showTimes { Text("\(message.timeInterval ?? 0)") }
                  Text(message.text)
                }
                .tag(message.id)
                .foregroundColor( chooseColor(message.text) )
              }
              Text("Bottom").hidden()
                .id(bottomID)
            }
            .onChange(of: viewStore.gotoFirst, perform: { _ in
              let id = viewStore.gotoFirst ? bottomID : topID
              proxy.scrollTo(id, anchor: viewStore.gotoFirst ? .bottomLeading : .topLeading)
            })
            .onChange(of: viewStore.filteredMessages.count, perform: { _ in
              let id = viewStore.gotoFirst ? bottomID : topID
              proxy.scrollTo(id, anchor: viewStore.gotoFirst ? .bottomLeading : .topLeading)
            })
            //            }
            //          .frame(alignment: .leading)
            .frame(minWidth: 900, maxWidth: .infinity, alignment: .leading)
            .font(.system(size: viewStore.fontSize, weight: .regular, design: .monospaced))
          }
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
