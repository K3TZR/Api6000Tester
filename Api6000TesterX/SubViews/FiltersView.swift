//
//  FiltersView.swift
//  Api6000Components/ApiViewer/Subviews/ViewerSubViews
//
//  Created by Douglas Adams on 8/10/20.
//

import SwiftUI

struct FiltersView: View {
  @ObservedObject var model: ApiModel
  
  var body: some View {
    HStack(spacing: 100) {
      FilterObjectsView(model: model)
      FilterMessagesView(model: model)
    }
  }
}

struct FilterObjectsView: View {
  @ObservedObject var model: ApiModel
  
  var body: some View {
    
    HStack {
      Picker("Show objects of type", selection: $model.objectFilter) {
        ForEach(ObjectFilter.allCases, id: \.self) {
          Text($0.rawValue).tag($0.rawValue)
        }
      }
      .pickerStyle(MenuPickerStyle())
    }
    .disabled(model.isConnected == false)
    .frame(width: 300)
  }
}

struct FilterMessagesView: View {
  @ObservedObject var model: ApiModel
  
  var body: some View {
    
    HStack {
      Picker("Show messages of type", selection: $model.messageFilter) {
        ForEach(MessageFilter.allCases, id: \.self) {
          Text($0.rawValue).tag($0.rawValue)
        }
      }
      .pickerStyle(MenuPickerStyle())
    }
    .disabled(model.isConnected == false)
    .frame(width: 300)
    
    Image(systemName: "x.circle").foregroundColor(model.isConnected == false ? .gray : nil)
      .disabled(model.isConnected == false)
      .onTapGesture {
        model.messageFilterText = ""
      }
    
    TextField("", text: model.$messageFilterText )
      .disabled(model.isConnected == false)
  }
}

struct FiltersView_Previews: PreviewProvider {
  
  static var previews: some View {
    FiltersView(model: ApiModel() )
    .frame(minWidth: 975)
    .padding()
  }
}
