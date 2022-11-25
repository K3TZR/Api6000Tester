//
//  MemoriesView.swift
//  Api6000Components/ApiViewer/Subviews/ObjectsSubViews
//
//  Created by Douglas Adams on 1/23/22.
//

// ----------------------------------------------------------------------------
// MARK: - View

import SwiftUI

import ApiModel

// highlight
// highlightColor

struct MemoryView: View {
  @ObservedObject var apiModel: ApiModel
  
  var body: some View {
    
    if apiModel.memories.count == 0 {
      HStack(spacing: 5) {
        Text("        MEMORYs ")
        Text("None present").foregroundColor(.red)
      }
    
    } else {
      ForEach(apiModel.memories) { memory in
        VStack(alignment: .leading) {
          DetailView1(memory: memory)
          DetailView2(memory: memory)
        }
      }
    }
  }
}

private struct DetailView1: View {
  @ObservedObject var memory: Memory
  
  var body: some View {
    HStack(spacing: 10) {
      Group {
        HStack(spacing: 5) {
          Text("         MEMORY ")
          Text("\(memory.id)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Name")
          Text(memory.name).foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Group")
          Text(memory.group.isEmpty ? "none" : memory.group).foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Owner")
          Text(memory.owner).foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Mode")
          Text(memory.mode).foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Frequency")
          Text("\(memory.frequency)").foregroundColor(.secondary)
        }
      }
      Group {
        HStack(spacing: 5) {
          Text("Step")
          Text("\(memory.step)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Power")
          Text("\(memory.rfPower)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Filter_Low")
          Text("\(memory.filterLow)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Filter_High")
          Text("\(memory.filterHigh)").foregroundColor(.secondary)
        }
      }
    }
  }
}

private struct DetailView2: View {
  @ObservedObject var memory: Memory
  
  var body: some View {
    HStack(spacing: 10) {
      Group {
        HStack(spacing: 5) {
          Text("        MEMORY")
          Text("\(memory.id)").foregroundColor(.secondary)
        }.hidden()

        HStack(spacing: 5) {
          Text("Squelch")
          Text(memory.squelchEnabled ? "Y" : "N").foregroundColor(memory.squelchEnabled ? .green : .red)
        }
        
        HStack(spacing: 5) {
          Text("Squelch_Level")
          Text("\(memory.squelchLevel)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Repeater")
          Text(memory.offsetDirection).foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Repeater_Offset")
          Text("\(memory.offset)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Tone")
          Text(memory.toneMode).foregroundColor(.secondary)
        }
      }
      Group {
        HStack(spacing: 5) {
          Text("Tone_Value")
          Text("\(String(format: "%3.0f", memory.toneValue))").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Mark")
          Text("\(memory.rttyMark)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("Shift")
          Text("\(memory.rttyShift)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("DIGL")
          Text("\(memory.digitalLowerOffset)").foregroundColor(.secondary)
        }
        
        HStack(spacing: 5) {
          Text("DIGU")
          Text("\(memory.digitalUpperOffset)").foregroundColor(.secondary)
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview
struct MemoryView_Previews: PreviewProvider {
  static var previews: some View {
    MemoryView(apiModel: ApiModel.shared)
      .frame(minWidth: 975)
      .padding()
  }
}
