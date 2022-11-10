//
//  ProfileView.swift
//  Api6000Tester
//
//  Created by Douglas Adams on 8/9/22.
//

import SwiftUI

import Api6000

struct ProfileView: View {
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    
    if viewModel.profiles.count == 0 {
      HStack(spacing: 5) {
        Text("PROFILEs")
        Text("None present").foregroundColor(.red)
      }
      .padding(.leading, 40)
      
    } else {
      VStack(alignment: .leading) {
        HeadingView()
        ForEach(viewModel.profiles) { profile in
          DetailView(profile: profile)
        }
      }
      .padding(.leading, 40)
    }
  }
}

private struct HeadingView: View {
  
  var body: some View {
    HStack(spacing: 10) {
      Text("PROFILE").frame(width: 60, alignment: .leading)
      Text("Type").frame(width: 50, alignment: .leading)
      Group {
        Text("Current")
        Text("List")
      }.frame(width: 150, alignment: .leading)
    }
    Text("")
  }
}

private struct DetailView: View {
  @ObservedObject var profile: Profile
  
  var body: some View {
    HStack(spacing: 10) {
      Text(profile.id.uppercased()).frame(width: 50, alignment: .leading)
      Text(profile.current).frame(width: 150, alignment: .leading)
      Text(profile.list.reduce("", { item1, item2 in item1 + item2 + ","}))
    }
    .padding(.leading, 70)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(viewModel: ViewModel.shared)
      .frame(minWidth: 1000)
      .padding()
  }
}
