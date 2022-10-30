//
//  TnfView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

import SwiftUI

import Api6000

// ----------------------------------------------------------------------------
// MARK: - View

struct TnfView: View {
  @ObservedObject var viewModel: ViewModel

  var body: some View {
    if viewModel.tnfs.count == 0 {
      HStack(spacing: 20) {
        Text("TNF").frame(width: 80, alignment: .leading)
        
        Text("None present").foregroundColor(.red)
      }
      .padding(.leading, 40)
      
    } else {
      ForEach(viewModel.tnfs) { tnf in
        DetailView(tnf: tnf)
      }
      .padding(.leading, 40)
    }
  }
}

private struct DetailView: View {
  @ObservedObject var tnf: Tnf
  
  func depthName(_ depth: UInt) -> String {
    switch depth {
    case 1: return "Normal"
    case 2: return "Deep"
    case 3: return "Very Deep"
    default:  return "Invalid"
    }
  }

  var body: some View {

    
    HStack(spacing: 20) {
      
      HStack(spacing: 5) {
        Text("TNF")
        Text(String(format: "%02d", tnf.id)).foregroundColor(.green)
      }
      .frame(width: 80, alignment: .leading)
      
      HStack(spacing: 0) {
        Text("Frequency").frame(width: 80, alignment: .leading)
        Text("\(tnf.frequency)").foregroundColor(.secondary).frame(width: 120, alignment: .trailing)
      }
      .padding(.trailing, 20)
      
      Group {
        HStack(spacing: 5) {
          Text("Width")
          Text("\(tnf.width)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Depth")
          Text(depthName(tnf.depth)).foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Permanent")
          Text(tnf.permanent ? "Y" : "N").foregroundColor(tnf.permanent ? .green : .red)
        }
      }.frame(width: 100, alignment: .leading)
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct TnfView_Previews: PreviewProvider {
  static var previews: some View {
    TnfView(viewModel: ViewModel.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
