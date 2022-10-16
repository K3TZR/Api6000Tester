//
//  MessagesModel.swift
//  Api6000Tester-C
//
//  Created by Douglas Adams on 10/15/22.
//

import IdentifiedCollections
import Foundation

import Api6000
import Shared

@MainActor
public final class MessagesModel: Equatable, ObservableObject {
  // ----------------------------------------------------------------------------
  // MARK: - Static Equality
  
  public nonisolated static func == (lhs: MessagesModel, rhs: MessagesModel) -> Bool {
    // object equality since it is a "sharedInstance"
    lhs === rhs
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - Initialization (Singleton)
  
  public static var shared = MessagesModel()
  private init() {}
  
  // ----------------------------------------------------------------------------
  // MARK: - Public properties
  
  var filter: MessageFilter = .all
  var filterText: String = ""
  var ignorePings = true
  var startTime: Date? = nil
  
  var messages = IdentifiedArrayOf<TcpMessage>()
  @Published var filteredMessages = IdentifiedArrayOf<TcpMessage>()
  
  
  var _subscriptionTask: Task<(), Never>?

  // ----------------------------------------------------------------------------
  // MARK: - Internal methods
  
  func start(_ time: Date) {
    startTime = time
    _subscriptionTask = Task {
      func ignoreReply(_ text: String) -> Bool {
        if text.first != "R" { return false }     // not a Reply
        let parts = text.components(separatedBy: "|")
        if parts.count < 3 { return false }       // incomplete
        if parts[1] != kNoError { return false }  // error of some type
        if parts[2] != "" { return false }        // additional data present
        return true                               // otherwise, ignore it
      }
      
      for await tcpMessage in Tcp.shared.testerInbound{
        // a TCP message was sent or received
        // ignore reply unless it is non-zero or contains additional data
        if tcpMessage.direction == .received && ignoreReply(tcpMessage.text) { continue }
        // a Tcp Message was sent or received
        // ignore sent "ping" messages unless showPings is true
        if tcpMessage.direction == .sent && tcpMessage.text.contains("ping") && ignorePings { continue }
        // set the time interval
//        tcpMessage.timeInterval = tcpMessage.timeStamp.timeIntervalSince(startTime!)
        addMessage(tcpMessage)
      }
    }
  }
  
  func stop() {
    _subscriptionTask?.cancel()
  }
  
  func addMessage(_ message: TcpMessage) {
    messages.append(message)
    filterMessages()
  }
  
  /// FIlter the Messages array
  func filterMessages() {
    // re-filter the messages array
    switch (filter, filterText) {
      
    case (.all, _):        filteredMessages = messages
    case (.prefix, ""):    filteredMessages = messages
    case (.prefix, _):     filteredMessages = messages.filter { $0.text.localizedCaseInsensitiveContains("|" + filterText) }
    case (.includes, _):   filteredMessages = messages.filter { $0.text.localizedCaseInsensitiveContains(filterText) }
    case (.excludes, ""):  filteredMessages = messages
    case (.excludes, _):   filteredMessages = messages.filter { !$0.text.localizedCaseInsensitiveContains(filterText) }
    case (.command, _):    filteredMessages = messages.filter { $0.text.prefix(1) == "C" }
    case (.S0, _):         filteredMessages = messages.filter { $0.text.prefix(3) == "S0|" }
    case (.status, _):     filteredMessages = messages.filter { $0.text.prefix(1) == "S" && $0.text.prefix(3) != "S0|"}
    case (.reply, _):      filteredMessages = messages.filter { $0.text.prefix(1) == "R" }
    }
  }
  
  func setFilter(_ filter: MessageFilter) {
    self.filter = filter
  }

  func setFilterText(_ filterText: String) {
    self.filterText = filterText
  }

  func clear() {
    messages.removeAll()
    filteredMessages.removeAll()
  }
}
