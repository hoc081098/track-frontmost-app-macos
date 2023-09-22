//
//  FontMostAppInfo.swift
//  Track Frontmost App
//
//  Created by Hoc Nguyen T. on 9/22/23.
//

import Foundation

struct FontMostAppInfo {
  let bundleIdentifier: String
  let name: String
  let date: Date
}

extension FontMostAppInfo: Equatable, Hashable { }

extension FontMostAppInfo: Identifiable {
  var id: String { bundleIdentifier }
}
