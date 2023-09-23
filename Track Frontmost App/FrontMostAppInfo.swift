//
//  FrontMostAppInfo.swift
//  Track Frontmost App
//
//  Created by Hoc Nguyen T. on 9/22/23.
//

import Foundation
import AppKit

struct FrontMostAppInfo {
  let bundleIdentifier: String
  let name: String
  let date: Date
  let totalUseTimeMs: TimeInterval
}

extension FrontMostAppInfo: Equatable, Hashable { }

extension FrontMostAppInfo: Identifiable {
  var id: String { bundleIdentifier }
}

extension FrontMostAppInfo {
  var icon: NSImage? {
    NSRunningApplication
      .runningApplications(withBundleIdentifier: bundleIdentifier)
      .first?.icon
  }
}
