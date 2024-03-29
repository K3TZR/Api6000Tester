//
//  Api6000TesterApp.swift
//  Api6000Tester
//
//  Created by Douglas Adams on 11/16/21.
//

import SwiftUI

import Api6000
import LogView
import Shared

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
struct Api6000TesterXApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self)
  var appDelegate

  var body: some Scene {

    WindowGroup("Api6000Tester  (v" + Version().string + ")") {
      ApiView(apiModel: ApiModel(), api6000: Model.shared)
        .toolbar {
          Button("Log View") { OpenWindows.LogView.open() }
          Button("Close") { NSApplication.shared.keyWindow?.close()  }
          Button("Close All") { NSApplication.shared.terminate(self)  }
        }
        .frame(minWidth: 975)
        .padding()
    }
    
    WindowGroup("Api6000Tester  (Log View)") {
      LogView(model: LogModel() )
      .toolbar {
        Button("Close") { NSApplication.shared.keyWindow?.close()  }
        Button("Close All") { NSApplication.shared.terminate(self)  }
      }
      .frame(minWidth: 975)
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
    if let url = URL(string: "Api6000Tester://\(self.rawValue)") {
      NSWorkspace.shared.open(url)
    }
  }
}
