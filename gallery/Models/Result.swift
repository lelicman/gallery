//
//  Result.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//

import Foundation

public class Result<T> {
  public let value: T?
  public let error: Error?

  public init(value: T? = nil, error: Error? = nil) {
    self.value = value
    self.error = error
  }
}
