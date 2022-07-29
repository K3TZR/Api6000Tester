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
  @ObservedObject var apiModel: ApiModel
  
  public var body: some View {
    
    VStack(alignment: .leading) {
      TopButtonsView(apiModel: apiModel)
      SendView(apiModel: apiModel)
      FiltersView(apiModel: apiModel)
      
      Divider().background(Color(.red))
      VSplitView {
        ObjectsView(apiModel: apiModel)
        Divider().background(Color(.green))
        MessagesView(apiModel: apiModel)
      }
      Spacer()
      Divider().background(Color(.red))
      BottomButtonsView(apiModel: apiModel)
    }
    .onAppear(perform: { apiModel.onAppear() } )
    // initialize on first appearance
    
    // alert dialogs
    //    .alert(
    //      self.store.scope(state: \.alert),
    //      dismiss: .alertDismissed
    //    )
    
    .sheet(isPresented: $apiModel.showProgress ) {
      ProgressView("Stopping")
    }
    
    // Picker sheet
    .sheet( isPresented: $apiModel.showPicker ) {
      PickerView(model: apiModel.pickerModel!)
    }
      
    // Login sheet
    .sheet( isPresented: $apiModel.showLogin ) {
      LoginView(model: apiModel.loginModel!)
    }
    
    // Connection sheet
    .sheet( isPresented: $apiModel.showClient ) {
      ClientView(model: apiModel.clientModel!)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct ApiView_Previews: PreviewProvider {
  static var previews: some View {
    ApiView(apiModel: ApiModel())
      .frame(minWidth: 975, minHeight: 400)
      .padding()
  }
}
