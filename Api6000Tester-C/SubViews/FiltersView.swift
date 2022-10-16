//
//  FiltersView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 8/10/20.
//

import ComposableArchitecture
import SwiftUI

struct FiltersView: View {
  let store: StoreOf<ApiModule>
  
  var body: some View {
    HStack(spacing: 100) {
      FilterObjectsView(store: store)
      FilterMessagesView(store: store)
    }
  }
}

struct FilterObjectsView: View {
  let store: StoreOf<ApiModule>
  
  var body: some View {
    
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack {
        Picker("Show Radio Objects of type", selection: viewStore.binding(
          get: \.objectFilter,
          send: { value in .objectsPicker(value) } )) {
            ForEach(ObjectFilter.allCases, id: \.self) {
              Text($0.rawValue)
            }
          }
          .frame(width: 300)
      }
    }
    .pickerStyle(MenuPickerStyle())
  }
}

struct FilterMessagesView: View {
  let store: StoreOf<ApiModule>

  var body: some View {

    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack {
        Picker("Show Tcp Messages of type", selection: viewStore.binding(
          get: \.messageFilter,
          send: { value in .messagesFilterPicker(value) } )) {
            ForEach(MessageFilter.allCases, id: \.self) {
              Text($0.rawValue)
            }
          }
          .frame(width: 300)
        Image(systemName: "x.circle")
          .onTapGesture {
            viewStore.send(.messagesFilterTextField(""))
          }
        TextField("filter text", text: viewStore.binding(
          get: \.messageFilterText,
          send: { value in ApiModule.Action.messagesFilterTextField(value) }))
      }
    }
    .pickerStyle(MenuPickerStyle())
  }
}

struct FiltersView_Previews: PreviewProvider {
  
  static var previews: some View {
    FiltersView(
      store: Store(
        initialState: ApiModule.State(),
        reducer: ApiModule()
      )
    )
    .frame(minWidth: 975)
    .padding()
  }
}
