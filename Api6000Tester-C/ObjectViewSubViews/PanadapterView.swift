//
//  PanadapterView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/24/22.
//

import IdentifiedCollections
import SwiftUI

import Api6000
import Shared

// ----------------------------------------------------------------------------
// MARK: - View

struct PanadapterView: View {
  @ObservedObject var viewModel: ViewModel
  let handle: Handle
  let showMeters: Bool
  
  var body: some View {
    
    if viewModel.panadapters.count == 0 {
      HStack(spacing: 5) {
        Text("PANADAPTERs")
        Text("None present").foregroundColor(.red)
      }
      .padding(.leading, 40)
      
    } else {
      ForEach(viewModel.panadapters.filter { $0.clientHandle == handle }) { panadapter in
        VStack(alignment: .leading) {
          // Panadapter
          PanadapterDetailView(panadapter: panadapter)
          
          // corresponding Waterfall
          ForEach(viewModel.waterfalls.filter { $0.panadapterId == panadapter.id} ) { waterfall in
            WaterfallDetailView(waterfall: waterfall)
          }
          
          // corresponding Slice(s)
          ForEach(viewModel.slices.filter { $0.panadapterId == panadapter.id}) { slice in
            SliceDetailView(slice: slice)
            
            // slice meter(s)
            if showMeters { MeterView(viewModel: viewModel, sliceId: slice.id, sliceClientHandle: slice.clientHandle, handle: handle) }
          }
        }
      }
      .padding(.leading, 40)
    }
  }
}

private struct PanadapterDetailView: View {
  @ObservedObject var panadapter: Panadapter
  
  var body: some View {
    HStack(spacing: 20) {
      HStack(spacing: 5) {
        Text("PANADAPTER")
        Text(panadapter.id.hex).foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Streaming")
        Text(panadapter.isStreaming ? "Y" : "N").foregroundColor(panadapter.isStreaming ? .green : .red)
      }
      
      HStack(spacing: 5) {
        Text("Center")
        Text("\(panadapter.center)").foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Bandwidth")
        Text("\(panadapter.bandwidth)").foregroundColor(.secondary)
      }
    }
  }
}

private struct WaterfallDetailView: View {
  @ObservedObject var waterfall: Waterfall
  
  var body: some View {
    HStack(spacing: 20) {
      HStack(spacing: 5) {
        Text("WATERFALL ")
        Text(waterfall.id.hex).foregroundColor(.secondary)
      }
      HStack(spacing: 5) {
        Text("Streaming")
        Text(waterfall.isStreaming ? "Y" : "N").foregroundColor(waterfall.isStreaming ? .green : .red)
      }
      
      HStack(spacing: 5) {
        Text("Auto_Black")
        Text(waterfall.autoBlackEnabled ? "Y" : "N").foregroundColor(waterfall.autoBlackEnabled ? .green : .red)
      }
      
      HStack(spacing: 5) {
        Text("Color_Gain")
        Text("\(waterfall.colorGain)").foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Black_Level")
        Text("\(waterfall.blackLevel)").foregroundColor(.secondary)
      }
      
      HStack(spacing: 5) {
        Text("Duration")
        Text("\(waterfall.lineDuration)").foregroundColor(.secondary)
      }
    }
  }
}

private struct SliceDetailView: View {
  @ObservedObject var slice: Slice
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 20) {
        
        HStack(spacing: 5) {
          Text("SLICE     ")
          Text(String(format: "%02d", slice.id)).foregroundColor(.green)
        }
        
        HStack(spacing: 5) {
          Text("Frequency")
          Text("\(slice.frequency)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Mode")
          Text("\(slice.mode)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Filter_Low")
          Text("\(slice.filterLow)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Filter_High")
          Text("\(slice.filterHigh)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Active")
          Text(slice.active ? "Y" : "N").foregroundColor(slice.active ? .green : .red)
        }
        
        HStack(spacing: 5) {
          Text("Locked")
          Text(slice.locked ? "Y" : "N").foregroundColor(slice.locked ? .green : .red)
        }
        
        HStack(spacing: 5) {
          Text("DAX_channel")
          Text("\(slice.daxChannel)").foregroundColor(.green)
        }
        
        HStack(spacing: 5) {
          Text("DAX_clients")
          Text("\(slice.daxClients)").foregroundColor(.green)
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct PanadapterView_Previews: PreviewProvider {
  static var previews: some View {
    PanadapterView(
      viewModel: ViewModel.shared,
      handle: 1,
      showMeters: true
    )
    .frame(minWidth: 1000)
    .padding()
  }
}
