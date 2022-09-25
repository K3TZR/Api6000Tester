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
      HStack(spacing: 10) {
        Text("        TNF  ")
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
        Text("Frequency")
        Text("\(tnf.frequency)").foregroundColor(.secondary)
      }
      
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
