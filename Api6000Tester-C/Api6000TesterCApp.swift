//
//  Api6000TesterApp-C.swift
//  Api6000Tester
//
//  Created by Douglas Adams on 11/16/21.
//

import ComposableArchitecture
import SwiftUI

import Api6000
import ApiModel
import EqFeature
import LogFeature
import RightSideFeature
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

private struct rightSideOpenKey: EnvironmentKey {
  static let defaultValue = false
}
extension EnvironmentValues {
  var rightSideOpen: Bool {
    get { self[rightSideOpenKey.self] }
    set { self[rightSideOpenKey.self] = newValue }
  }
}

enum WindowType: String {
  case left = "Left View"
  case log = "Log View"
  case panadapter = "Panadapter"
  case right = "Right View"
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
  @Dependency(\.viewModel) var viewModel
  @Dependency(\.apiModel) var apiModel

  var body: some Scene {

    WindowGroup("Api6000Tester-C  (v" + Version().string + ")") {
      ApiView(store: Store(
        initialState: ApiModule.State(),
        reducer: ApiModule())
      )
      .frame(minWidth: 975)
      .padding(.horizontal, 20)
      .padding(.vertical, 10)

      .toolbar {
        Spacer()
        Button(WindowType.panadapter.rawValue) { openWindow(id: WindowType.panadapter.rawValue) }
        Button(WindowType.log.rawValue) { openWindow(id: WindowType.log.rawValue) }
        Button(WindowType.left.rawValue) { openWindow(id: WindowType.left.rawValue) }
        Button(WindowType.right.rawValue) { openWindow(id: WindowType.right.rawValue) }
        Button("Close") { NSApplication.shared.terminate(self)  }
      }
    }

    Window(WindowType.log.rawValue, id: WindowType.log.rawValue) {
      LogView(store: Store(initialState: LogFeature.State(), reducer: LogFeature()) )
      .toolbar {
        Button("Close") { NSApplication.shared.keyWindow?.close()  }
        Button("Close All") { NSApplication.shared.terminate(self)  }
      }
      .frame(minWidth: 975)
    }
    .windowStyle(.hiddenTitleBar)
    .defaultPosition(.bottomTrailing)

    Window(WindowType.right.rawValue, id: WindowType.right.rawValue) {
      RightSideView(store: Store(initialState: RightSideFeature.State(), reducer: RightSideFeature()), apiModel: apiModel)
      .toolbar {
        Button("Close") { NSApplication.shared.keyWindow?.close()  }
        Button("Close All") { NSApplication.shared.terminate(self)  }
      }
      .frame(width: 275)
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(WindowResizability.contentSize)
    .defaultPosition(.topTrailing)
    
    Window(WindowType.left.rawValue, id: WindowType.left.rawValue) {
      RightSideView(store: Store(initialState: RightSideFeature.State(), reducer: RightSideFeature()), apiModel: apiModel)
      .toolbar {
        Button("Close") { NSApplication.shared.keyWindow?.close()  }
        Button("Close All") { NSApplication.shared.terminate(self)  }
      }
      .frame(width: 275)
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(WindowResizability.contentSize)
    .defaultPosition(.topLeading)
    
    Window(WindowType.panadapter.rawValue, id: WindowType.panadapter.rawValue) {
      VStack {
        Text("\(WindowType.panadapter.rawValue) goes here")
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

//enum OpenWindows: String, CaseIterable {
//  case LogView = "LogView"
//
//  func open() {
//    if let url = URL(string: "Api6000Tester://\(self.rawValue)") {
//      NSWorkspace.shared.open(url)
//    }
//  }
//}
