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
import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

public struct ApiView: View {
  @ObservedObject var apiModel: ApiModel
  @ObservedObject var api6000: Model

  public var body: some View {
    
    
    VStack(alignment: .leading) {
      TopButtonsView(apiModel: apiModel)
      SendView(apiModel: apiModel)
      FiltersView(apiModel: apiModel)
      Divider().background(.gray)

        VSplitView {
          ObjectsView(apiModel: apiModel, api6000: api6000)
            .frame(minWidth: 900, maxWidth: .infinity, alignment: .leading)
          
          Divider().background(.cyan)
          MessagesView(apiModel: apiModel, api6000: api6000)
            .frame(minWidth: 900, maxWidth: .infinity, alignment: .leading)
          
        }
      Spacer()
      Divider().background(.gray)
      BottomButtonsView(apiModel: apiModel)
    }
    .frame(minWidth: 900, maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    
    // initialize on first appearance
    .onAppear(perform: { apiModel.onAppear() } )
    
     // alert dialogs
    .sheet( isPresented: $apiModel.showAlert ) {
      AlertView(model: apiModel.alertModel!)
    }
    
    // Picker sheet
    .sheet( isPresented: $apiModel.showPicker) {
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
    ApiView(apiModel: ApiModel(), api6000: Model.shared)
      .frame(minWidth: 900)
      .padding(.horizontal)
  }
}
