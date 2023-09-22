//
//  FontMostAppInfoViewModel.swift
//  Track Frontmost App
//
//  Created by Hoc Nguyen T. on 9/22/23.
//

import Foundation
import Combine
import AppKit

private let currentAppBundleIdentifier = Bundle.main.bundleIdentifier!

@MainActor
class FontMostAppInfoViewModel: ObservableObject {
  @Published
  private(set) var infos = [FontMostAppInfo]()
  
  init() {
    print("currentAppBundleIdentifier=\(currentAppBundleIdentifier)")

    NSWorkspace.shared
      .publisher(for: \.frontmostApplication)
      .compactMap { (appInfo: NSRunningApplication?) -> FontMostAppInfo? in
        guard
          let appInfo = appInfo,
          appInfo.bundleIdentifier != currentAppBundleIdentifier,
          let bundleIdentifier = appInfo.bundleIdentifier,
          let localizedName = appInfo.localizedName
        else { return nil }
        
        return FontMostAppInfo(
          bundleIdentifier: bundleIdentifier,
          name: localizedName,
          date: Date()
        )
      }
      .scan([FontMostAppInfo]()) { state, appInfo in
        var newState = [FontMostAppInfo]()
        newState.reserveCapacity(state.count + 1)
        
        state.forEach {
          if $0.bundleIdentifier != appInfo.bundleIdentifier {
            newState.append($0)
          }
        }
        newState.append(appInfo)
        
        return newState
      }
      .assign(to: &$infos)
  }
}
