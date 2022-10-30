//
//  MessagesModel.swift
//  Api6000Tester-C
//
//  Created by Douglas Adams on 10/15/22.
//

import ComposableArchitecture
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
    
  @Published var filteredMessages = IdentifiedArrayOf<TcpMessage>()
  
  // ----------------------------------------------------------------------------
  // MARK: - Private properties
  
  private var _filter: MessageFilter = .all
  private var _filterText: String = ""
  private var _ignorePings = true
  private var _messages = IdentifiedArrayOf<TcpMessage>()
  private var _subscriptionTask: Task<(), Never>?

  // ----------------------------------------------------------------------------
  // MARK: - Public methods
  
  public func start() {
    _subscriptionTask = Task {
      
      // ignore routine replies (i.e. no error or attached data)
      func ignoreReply(_ text: String) -> Bool {
        if text.first != "R" { return false }     // not a Reply
        let parts = text.components(separatedBy: "|")
        if parts.count < 3 { return false }       // incomplete
        if parts[1] != kNoError { return false }  // error of some type
        if parts[2] != "" { return false }        // additional data present
        return true                               // otherwise, ignore it
      }
      
      // wait for a TCP message to be sent or received
      for await tcpMessage in Tcp.shared.testerStream{
        // ignore received replies unless they are non-zero or contain additional data
        if tcpMessage.direction == .received && ignoreReply(tcpMessage.text) { continue }
        // ignore sent "ping" messages unless showPings is true
        if tcpMessage.direction == .sent && tcpMessage.text.contains("ping") && _ignorePings { continue }
        addMessage(tcpMessage)
      }
    }
  }
  
  public func stop() {
    _subscriptionTask?.cancel()
  }

  /// FIlter a message
  public func filterMessage(_ message: TcpMessage) {
    
    // append to the messages array
    switch (_filter, _filterText) {
      
    case (.all, _):        filteredMessages.append(message)
    case (.prefix, ""):    filteredMessages.append(message)
    case (.prefix, _):     if message.text.localizedCaseInsensitiveContains("|" + _filterText) { filteredMessages.append(message) }
    case (.includes, _):   if message.text.localizedCaseInsensitiveContains(_filterText) { filteredMessages.append(message) }
    case (.excludes, ""):  filteredMessages.append(message)
    case (.excludes, _):   if !message.text.localizedCaseInsensitiveContains(_filterText) { filteredMessages.append(message) }
    case (.command, _):    if message.text.prefix(1) == "C" { filteredMessages.append(message) }
    case (.S0, _):         if message.text.prefix(3) == "S0|" { filteredMessages.append(message) }
    case (.status, _):     if message.text.prefix(1) == "S" && message.text.prefix(3) != "S0|" { filteredMessages.append(message) }
    case (.reply, _):      if message.text.prefix(1) == "R" { filteredMessages.append(message) }
    }
  }
      
  /// Filter the entire messages array
  public func filterMessages() {
    // re-filter the entire messages array
    switch (_filter, _filterText) {
      
    case (.all, _):        filteredMessages = _messages
    case (.prefix, ""):    filteredMessages = _messages
    case (.prefix, _):     filteredMessages = _messages.filter { $0.text.localizedCaseInsensitiveContains("|" + _filterText) }
    case (.includes, _):   filteredMessages = _messages.filter { $0.text.localizedCaseInsensitiveContains(_filterText) }
    case (.excludes, ""):  filteredMessages = _messages
    case (.excludes, _):   filteredMessages = _messages.filter { !$0.text.localizedCaseInsensitiveContains(_filterText) }
    case (.command, _):    filteredMessages = _messages.filter { $0.text.prefix(1) == "C" }
    case (.S0, _):         filteredMessages = _messages.filter { $0.text.prefix(3) == "S0|" }
    case (.status, _):     filteredMessages = _messages.filter { $0.text.prefix(1) == "S" && $0.text.prefix(3) != "S0|"}
    case (.reply, _):      filteredMessages = _messages.filter { $0.text.prefix(1) == "R" }
    }
  }
  
  public func setFilter(_ filter: MessageFilter) {
    _filter = filter
  }

  public func setFilterText(_ filterText: String) {
    _filterText = filterText
  }

  public func clear() {
    _messages.removeAll()
    filteredMessages.removeAll()
  }

  // ----------------------------------------------------------------------------
  // MARK: - Private methods
  
  private func addMessage(_ message: TcpMessage) {
    _messages.append(message)
    filterMessage(message)
  }
  
}
