//
//  FrontMostAppInfo.swift
//  Track Frontmost App
//
//  Created by Hoc Nguyen T. on 9/22/23.
//

import Foundation

struct FrontMostAppInfo {
  let bundleIdentifier: String
  let name: String
  let date: Date
}

extension FrontMostAppInfo: Equatable, Hashable { }

extension FrontMostAppInfo: Identifiable {
  var id: String { bundleIdentifier }
}
