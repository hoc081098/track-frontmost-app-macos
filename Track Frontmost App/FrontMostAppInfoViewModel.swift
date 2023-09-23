//
//  FrontMostAppInfoViewModel.swift
//  Track Frontmost App
//
//  Created by Hoc Nguyen T. on 9/22/23.
//

import Foundation
import Combine
import AppKit

private let currentAppBundleIdentifier = Bundle.main.bundleIdentifier!

@MainActor
class FrontMostAppInfoViewModel: ObservableObject {
  @Published
  private(set) var infos = [FrontMostAppInfo]()

  init() {
    print("currentAppBundleIdentifier=\(currentAppBundleIdentifier)")

    NSWorkspace.shared
      .publisher(for: \.frontmostApplication)
      .compactMap { (appInfo: NSRunningApplication?) -> (bundleIdentifier: String, name: String, date: Date)? in
      guard
        let appInfo = appInfo,
        let bundleIdentifier = appInfo.bundleIdentifier
        else { return nil }

      return (
        bundleIdentifier,
        appInfo.localizedName ?? "Unknown name 🥺",
        Date()
      )
    }
      .scan(infos, reduce)
      .assign(to: &$infos)
  }
}

private func reduce(
  state: [FrontMostAppInfo],
  newItem: (bundleIdentifier: String, name: String, date: Date)
) -> [FrontMostAppInfo] {
  if newItem.bundleIdentifier == currentAppBundleIdentifier {
    var newState = state
    if let last = state.last {
      newState[newState.count - 1] = FrontMostAppInfo(
        bundleIdentifier: last.bundleIdentifier,
        name: last.name,
        date: last.date,
        totalUseTimeMs: last.totalUseTimeMs + last.date.distance(to: newItem.date)
      )
    }
    return newState
  }

  var newState = [FrontMostAppInfo]()
  newState.reserveCapacity(state.count + 1)

  if !state.isEmpty {
    var existing: FrontMostAppInfo?

    state.forEach {
      if $0.bundleIdentifier != newItem.bundleIdentifier {
        newState.append($0)
      } else {
        existing = $0
      }
    }

    if let last = newState.last, last.bundleIdentifier != existing?.bundleIdentifier {
      newState[newState.count - 1] = FrontMostAppInfo(
        bundleIdentifier: last.bundleIdentifier,
        name: last.name,
        date: last.date,
        totalUseTimeMs: last.totalUseTimeMs + last.date.distance(to: newItem.date)
      )
    }

    newState.append(
      FrontMostAppInfo(
        bundleIdentifier: newItem.bundleIdentifier,
        name: newItem.name,
        date: newItem.date,
        totalUseTimeMs: existing?.totalUseTimeMs ?? 0
      )
    )
  } else {
    newState.append(
      FrontMostAppInfo(
        bundleIdentifier: newItem.bundleIdentifier,
        name: newItem.name,
        date: newItem.date,
        totalUseTimeMs: 0
      )
    )
  }

  return newState
}
