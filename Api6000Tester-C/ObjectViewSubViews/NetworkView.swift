//
//  NetworkView.swift
//  Api6000Tester-C
//
//  Created by Douglas Adams on 10/3/22.
//

import SwiftUI

import Api6000

struct User: Identifiable {
  let id: Int
  var name: String
  var score: Int
  var other: Int
}


public struct NetworkView: View {
  
  @State private var users = [
    User(id: 1, name: "Taylor Swift", score: 90, other: 200),
    User(id: 2, name: "Justin Bieber", score: 80, other: 300),
    User(id: 3, name: "Adele Adkins", score: 85, other: 400)
  ]
  
  @State private var sortOrder = [KeyPathComparator(\User.name)]
  @State private var selection: User.ID?
  
  public var body: some View {
    
//    let _ = Self._printChanges()
    
    VStack {
      Text("Top")
      
      Table(users) {
          TableColumn("Name", value: \.name)
          TableColumn("Score") { user in
              Text(String(user.score))
          }
      }
      .border(.red)
      Text("Bottom")
    }
    .frame(width: 400, height: 200)
    .border(.green)
  }

  
//  let streamModel: StreamModel
//
//  public var body: some View {
//
//    let _ = Self._printChanges()
//
//    VStack {
//      Text("Top")
//      HStack {
//        Text("Panadapter")
//        Text("\(streamModel.packetsPanadapter)")
//      }
//      HStack {
//        Text("Waterfall")
//        Text("\(streamModel.packetsWaterfall)")
//      }
//      Text("Bottom")
//    }
//  }
}


struct NetworkView_Previews: PreviewProvider {
  static var previews: some View {
    NetworkView()
  }
}
