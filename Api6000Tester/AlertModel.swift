//
//  AlertModel.swift
//  Api6000TesterX
//
//  Created by Douglas Adams on 7/30/22.
//

import Foundation

public struct AlertModel {

  public init(
    title: String,
    message: String? = nil,
    text: String? = nil,
    action: @escaping () -> Void
  )
  {
    self.title = title
    self.message = message
    self.text = text
    self.action = action

  }
  public var title: String
  public var message: String?
  public var text: String?
  public var action: () -> Void
}
