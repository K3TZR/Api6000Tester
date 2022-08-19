//
//  ProfileView.swift
//  Api6000Tester
//
//  Created by Douglas Adams on 8/9/22.
//

import SwiftUI
import Api6000

struct ProfileView: View {
  @ObservedObject var model: Model
  
  var body: some View {
    
    if model.profiles.count == 0 {
      HStack(spacing: 5) {
        Text("            PROFILEs")
        Text("None present").foregroundColor(.red)
      }
      
    } else {
      ForEach(model.profiles) { profile in
        VStack(spacing: 20) {
          HStack(spacing: 10) {
            HStack(spacing: 5) {
              Text("         PROFILE")
              Text(profile.id)
                .frame(width: 50, alignment: .leading)
                .foregroundColor(.secondary)
            }
            .padding(.top, 10)
            
            HStack(spacing: 5) {
              Text("Current")
              Text(profile.current)
                .frame(width: 100, alignment: .leading)
                .foregroundColor(.secondary)
            }
            .padding(.top, 10)
            
            HStack(spacing: 5) {
              Text("List")
              Text(profile.list.reduce("", { item1, item2 in item1 + item2 + ","}))
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(.secondary)
            }
          }
        }
      }
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(model: Model.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
