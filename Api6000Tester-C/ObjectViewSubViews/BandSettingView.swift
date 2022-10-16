//
//  BandSettingsView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import IdentifiedCollections
import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct BandSettingView: View {
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    
    if viewModel.bandSettings.count == 0 {
      HStack(spacing: 5) {
        Text("BANDSETTINGs")
        Text("None present").foregroundColor(.red)
      }
      .padding(.leading, 40)
      
    } else {
      VStack(alignment: .leading) {
        HeadingView()
        ForEach(viewModel.bandSettings.sorted(by: {$0.name < $1.name})) { setting in
          DetailView(setting: setting)
        }
      }
      .padding(.leading, 40)
      //      DetailTableView(viewModel: viewModel)
    }
  }
}

private struct HeadingView: View {
  
  var body: some View {
    HStack(spacing: 10) {
      Text("BAND").frame(width: 80, alignment: .leading)
      Group {
        Text("Rf Power")
        Text("Tune Power")
      }.frame(width: 80)
      Group {
        Text("Tx1")
        Text("Tx2")
        Text("Tx3")
        Text("Acc Tx")
      }.frame(width: 60)
      Group {
        Text("Acc Tx Req")
        Text("Rca Tx Req")
      }.frame(width: 80)
      Group {
        Text("HW Alc")
        Text("Inhibit")
      }.frame(width: 60)
    }
    Text("")
  }
}

private struct DetailView: View {
  @ObservedObject var setting: BandSetting
  
  var body: some View {
    HStack(spacing: 10) {
      Group {
        Text(setting.name == 999 ? " GEN" : String(format: "%#4d", setting.name))
        Text(String(format: "%#3d", setting.rfPower))
        Text(String(format: "%#3d", setting.tunePower))
      }.frame(width: 80)
      Group {
        Text(setting.tx1Enabled ? "Y" : "N").foregroundColor(setting.tx1Enabled  ? .green : .red)
        Text(setting.tx2Enabled ? "Y" : "N").foregroundColor(setting.tx2Enabled  ? .green : .red)
        Text(setting.tx3Enabled ? "Y" : "N").foregroundColor(setting.tx3Enabled  ? .green : .red)
        Text(setting.accTxEnabled ? "Y" : "N").foregroundColor(setting.accTxEnabled  ? .green : .red)
      }.frame(width: 60)
      Group {
        Text(setting.accTxReqEnabled ? "Y" : "N").foregroundColor(setting.accTxReqEnabled ? .green : .red)
        Text(setting.rcaTxReqEnabled ? "Y" : "N").foregroundColor(setting.rcaTxReqEnabled ? .green : .red)
      }.frame(width: 80)
      Group {
        Text(setting.hwAlcEnabled ? "Y" : "N").foregroundColor(setting.hwAlcEnabled ? .green : .red)
        Text(setting.inhibit ? "Y" : "N").foregroundColor(setting.inhibit ? .green : .red)
      }.frame(width: 60)
    }
  }
}

//private struct DetailTableTopView: View {
//  @ObservedObject var viewModel: ViewModel
//
//  var body: some View {
//      TableColumn("Band", content: { setting in Text(String(format: "%#3d", setting.tunePower)) }).width(50)
//      TableColumn("Rf Power", content: { setting in Text(String(format: "%#3d", setting.tunePower)) }).width(70)
//      TableColumn("Tune Power", content: { setting in Text(String(format: "%#3d", setting.tunePower)) }).width(70)
//      TableColumn("Tx1", content: { setting in Text(setting.tx1Enabled ? "Y" : "N").foregroundColor(setting.tx1Enabled  ? .green : .red) }).width(30)
//      TableColumn("Tx2", content: { setting in Text(setting.tx2Enabled ? "Y" : "N").foregroundColor(setting.tx2Enabled  ? .green : .red) }).width(30)
//      TableColumn("Tx3", content: { setting in Text(setting.tx3Enabled ? "Y" : "N").foregroundColor(setting.tx3Enabled  ? .green : .red) }).width(30)
//  }
//    .frame(height: 200, alignment: .trailing)
//}

//private struct DetailTableBottomView: View {
//  @ObservedObject var viewModel: ViewModel
//
//  var body: some View {
//    TableColumn("Acc Tx", content: { setting in Text(setting.accTxEnabled ? "Y" : "N").foregroundColor(setting.accTxEnabled  ? .green : .red) }).width(60)
//    TableColumn("Acc Tx Req", content: { setting in Text(setting.accTxReqEnabled ? "Y" : "N").foregroundColor(setting.accTxReqEnabled  ? .green : .red) }).width(70)
//    TableColumn("Rca Tx Req", content: { setting in Text(setting.rcaTxReqEnabled ? "Y" : "N").foregroundColor(setting.rcaTxReqEnabled  ? .green : .red) }).width(70)
//    TableColumn("HW Alc", content: { setting in Text(setting.hwAlcEnabled ? "Y" : "N").foregroundColor(setting.hwAlcEnabled  ? .green : .red) }).width(60)
//    TableColumn("Inhibit", content: { setting in Text(setting.inhibit ? "Y" : "N").foregroundColor(setting.inhibit  ? .green : .red) })
//    TableColumn("Inhibit", content: { setting in Text(setting.inhibit ? "Y" : "N").foregroundColor(setting.inhibit  ? .green : .red) })
//  }
//    .frame(height: 200, alignment: .trailing)
//}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct BandSettingView_Previews: PreviewProvider {
  static var previews: some View {
    BandSettingView(viewModel: ViewModel.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
