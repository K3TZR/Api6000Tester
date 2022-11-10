//
//  Api6000TesterApp-C.swift
//  Api6000Tester
//
//  Created by Douglas Adams on 11/16/21.
//

import ComposableArchitecture
import SwiftUI

import Api6000
import LogFeature
import Shared

extension MessagesModel: DependencyKey {
  public static let liveValue = MessagesModel.shared
}

extension DependencyValues {
  var messagesModel: MessagesModel {
    get { self[MessagesModel.self] }
    set { self[MessagesModel.self] = newValue }
  }
}

extension StreamModel: DependencyKey {
  public static let liveValue = StreamModel.shared
}

extension DependencyValues {
  var streamModel: StreamModel {
    get { self[StreamModel.self] }
    set { self[StreamModel.self] = newValue }
  }
}

extension PacketModel: DependencyKey {
  public static let liveValue = PacketModel.shared
}

extension DependencyValues {
  var packetModel: PacketModel {
    get { self[PacketModel.self] }
    set { self[PacketModel.self] = newValue }
  }
}

extension ViewModel: DependencyKey {
  public static let liveValue = ViewModel.shared
}

extension DependencyValues {
  var viewModel: ViewModel {
    get { self[ViewModel.self] }
    set { self[ViewModel.self] = newValue }
  }
}




final class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    // disable tab view
    NSWindow.allowsAutomaticWindowTabbing = false
  }
  
  func applicationWillTerminate(_ notification: Notification) {
    log("Api6000Tester: application terminated", .debug, #function, #file, #line)
  }
  
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    true
  }
}

@main
struct Api6000TesterCApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self)
  var appDelegate
  
  @Environment(\.openWindow) var openWindow
  
  var body: some Scene {

    WindowGroup("Api6000Tester-C  (v" + Version().string + ")") {
      ApiView(store: Store(
        initialState: ApiModule.State(),
        reducer: ApiModule())
      )
        .toolbar {
          Button("Panadapter") { openWindow(id: "panadapter") }
          Button("Log View") { openWindow(id: "logview") }
          Button("Close") { NSApplication.shared.keyWindow?.close()  }
          Button("Close All") { NSApplication.shared.terminate(self)  }
        }
        .frame(minWidth: 975)
        .padding()
    }
    
    Window("Log View", id: "logview") {
      LogView(store: Store(initialState: LogFeature.State(), reducer: LogFeature()) )
      .toolbar {
        Button("Close") { NSApplication.shared.keyWindow?.close()  }
        Button("Close All") { NSApplication.shared.terminate(self)  }
      }
      .frame(minWidth: 975)
//      .padding()
    }
    .windowStyle(.hiddenTitleBar)
    .defaultPosition(.bottomTrailing)

    
    Window("Panadapter", id: "panadapter") {
      VStack {
        Text("Pandapter goes here")
      }
      .toolbar {
        Button("Close") { NSApplication.shared.keyWindow?.close()  }
        Button("Close All") { NSApplication.shared.terminate(self)  }
      }
      .frame(minWidth: 975)
      .padding()
    }
    .windowStyle(.hiddenTitleBar)
    .defaultPosition(.topTrailing)

    .commands {
      //remove the "New" menu item
      CommandGroup(replacing: CommandGroupPlacement.newItem) {}
    }
  }
}

enum OpenWindows: String, CaseIterable {
  case LogView = "LogView"
  
  func open() {
    if let url = URL(string: "Api6000Tester://\(self.rawValue)") {
      NSWorkspace.shared.open(url)
    }
  }
}
