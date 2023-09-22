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
      .compactMap { (appInfo: NSRunningApplication?) -> FrontMostAppInfo? in
        guard
          let appInfo = appInfo,
          appInfo.bundleIdentifier != currentAppBundleIdentifier,
          let bundleIdentifier = appInfo.bundleIdentifier
        else { return nil }
        
        return FrontMostAppInfo(
          bundleIdentifier: bundleIdentifier,
          name: appInfo.localizedName ?? "Unkown name 🥺",
          date: Date()
        )
      }
      .scan(infos) { state, appInfo in
        var newState = [FrontMostAppInfo]()
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
