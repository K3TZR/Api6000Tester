//
//  Api6000TesterApp.swift
//  Api6000Tester
//
//  Created by Douglas Adams on 11/16/21.
//

import SwiftUI
import ComposableArchitecture

import LogView
import Shared

final class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    // disable tab view
    NSWindow.allowsAutomaticWindowTabbing = false
  }
  
  func applicationWillTerminate(_ notification: Notification) {
    NotificationCenter.default.post(name: logEntryNotification, object: LogEntry("Api6000TesterX: application terminated", .debug, #function, #file, #line))
  }
  
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    true
  }
}

@main
struct Api6000TesterXApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self)
  var appDelegate

  var body: some Scene {

    WindowGroup("Api6000TesterX  (v" + Version().string + ")") {
      ApiView(model: ApiModel())
        .toolbar {
          Button("Log View") { OpenWindows.LogView.open() }
          Button("Close") { NSApplication.shared.keyWindow?.close()  }
          Button("Close All") { NSApplication.shared.terminate(self)  }
        }
        .frame(minWidth: 975, minHeight: 400)
        .padding()
    }
    
    WindowGroup("Api6000TesterX  (Log View)") {
      LogView(store: Store(
        initialState: LogState(),
        reducer: logReducer,
        environment: LogEnvironment() )
      )
      .toolbar {
        Button("Close") { NSApplication.shared.keyWindow?.close()  }
      }
      .frame(minWidth: 975, minHeight: 400)
      .padding()
    }.handlesExternalEvents(matching: Set(arrayLiteral: "LogView"))
    
    .commands {
      //remove the "New" menu item
      CommandGroup(replacing: CommandGroupPlacement.newItem) {}
    }
  }
}

enum OpenWindows: String, CaseIterable {
  case LogView = "LogView"
  
  func open() {
    if let url = URL(string: "Api6000TesterX://\(self.rawValue)") {
      NSWorkspace.shared.open(url)
    }
  }
}
