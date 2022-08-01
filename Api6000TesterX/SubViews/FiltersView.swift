//
//  FiltersView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 8/10/20.
//

import SwiftUI

struct FiltersView: View {
  @ObservedObject var apiModel: ApiModel
  
  var body: some View {
    HStack(spacing: 100) {
      FilterObjectsView(apiModel: apiModel)
      FilterMessagesView(apiModel: apiModel)
    }
  }
}

struct FilterObjectsView: View {
  @ObservedObject var apiModel: ApiModel
  
  var body: some View {
    
    HStack {
      Picker("Show objects of type", selection: $apiModel.objectFilter) {
        ForEach(ObjectFilter.allCases, id: \.self) {
          Text($0.rawValue).tag($0.rawValue)
        }
      }
      .pickerStyle(MenuPickerStyle())
    }
    .frame(width: 300)
  }
}

struct FilterMessagesView: View {
  @ObservedObject var apiModel: ApiModel
  
  var body: some View {
    
    HStack {
      Picker("Show messages of type", selection: $apiModel.messageFilter) {
        ForEach(MessageFilter.allCases, id: \.self) {
          Text($0.rawValue).tag($0.rawValue)
        }
      }
      .pickerStyle(MenuPickerStyle())
      .frame(width: 300)
      
      Image(systemName: "x.circle").foregroundColor(apiModel.isConnected == false ? .gray : nil)
        .disabled(apiModel.isConnected == false)
        .onTapGesture {
          apiModel.messageFilterText = ""
        }
      
      TextField("message filter text", text: $apiModel.messageFilterText )
    }
  }
}

struct FiltersView_Previews: PreviewProvider {
  
  static var previews: some View {
    FiltersView(apiModel: ApiModel() )
    .frame(minWidth: 975)
    .padding()
  }
}
