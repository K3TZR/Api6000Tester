//
//  ApiView.swift
//  Api6000Components/ApiViewer
//
//  Created by Douglas Adams on 12/1/21.
//

import SwiftUI

import LoginView
import ClientView
import PickerView
import LogView
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

public struct ApiView: View {
  @ObservedObject var model: ApiModel
  
  public var body: some View {
    
    VStack(alignment: .leading) {
      TopButtonsView(model: model)
      SendView(model: model)
      FiltersView(model: model)
      
      Divider().background(Color(.red))
      VSplitView {
        ObjectsView(model: model)
        Divider().background(Color(.green))
        MessagesView(model: model)
      }
      Spacer()
      Divider().background(Color(.red))
      BottomButtonsView(model: model)
    }
    .onAppear(perform: { model.onAppear() } )
    // initialize on first appearance
    
    // alert dialogs
    //    .alert(
    //      self.store.scope(state: \.alert),
    //      dismiss: .alertDismissed
    //    )
    
    .sheet(isPresented: $model.showProgress ) {
      ProgressView("Stopping")
    }
    
    // Picker sheet
    .sheet( isPresented: $model.showPicker ) {
      PickerView(model: model.pickerModel!)
    }
      
    // Login sheet
    .sheet( isPresented: $model.showLogin ) {
      LoginView(model: model.loginModel!)
    }
    
    // Connection sheet
    .sheet( isPresented: $model.showClient ) {
      ClientView(model: model.clientModel!)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct ApiView_Previews: PreviewProvider {
  static var previews: some View {
    ApiView(model: ApiModel())
      .frame(minWidth: 975, minHeight: 400)
      .padding()
  }
}
