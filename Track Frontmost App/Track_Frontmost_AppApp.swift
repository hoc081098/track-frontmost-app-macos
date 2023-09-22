//
//  Track_Frontmost_AppApp.swift
//  Track Frontmost App
//
//  Created by Hoc Nguyen T. on 9/22/23.
//

import SwiftUI

private let startTime = Date()

@main
struct Track_Frontmost_AppApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(viewModel: .init())
        .frame(
          maxWidth: .infinity,
          maxHeight: .infinity
        )
        .navigationTitle("Start time: \(startTime)")
    }
  }
}
