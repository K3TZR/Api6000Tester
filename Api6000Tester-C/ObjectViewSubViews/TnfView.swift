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

  let pre = String(repeating: " ", count: 6)
  let post = String(repeating: " ", count: 6)

  var body: some View {
    if viewModel.tnfs.count == 0 {
      HStack(spacing: 0) {
        Text(pre + "TNF" + post)
        Text("None present").foregroundColor(.red)
      }
      
    } else {
      ForEach(viewModel.tnfs) { tnf in
        VStack (alignment: .leading) {
          DetailView(tnf: tnf)
        }
      }
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
    HStack(spacing: 10) {
      
      HStack(spacing: 10) {
        Text("        TNF  ")
        Text(String(format: "%02d", tnf.id)).foregroundColor(.green)
      }
      
      HStack(spacing: 5) {
        Text("Frequency").frame(width: 80, alignment: .leading)
        Text("\(tnf.frequency)").foregroundColor(.secondary).frame(width: 80, alignment: .trailing)
      }
      
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
      }
      .frame(width: 100)
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
