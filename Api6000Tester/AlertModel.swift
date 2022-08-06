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
    buttonText: String? = nil
  )
  {
    self.title = title
    self.message = message
    self.buttonText = buttonText

  }
  public var title: String
  public var message: String?
  public var buttonText: String?
}
