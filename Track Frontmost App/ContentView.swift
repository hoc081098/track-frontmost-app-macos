//
//  ContentView.swift
//  Track Frontmost App
//
//  Created by Hoc Nguyen T. on 9/22/23.
//

import SwiftUI

struct ContentView: View {
  private let formatter = durationFormatter()
  private let iconLoader = IconLoader()

  @ObservedObject
  var viewModel: FrontMostAppInfoViewModel

  var body: some View {
    List {
      ForEach(viewModel.infos) { info in
        HStack {

          if let icon = iconLoader.icon(for: info) {
            Image(nsImage: icon)
              .resizable()
              .frame(width: 48, height: 48)
              .padding(.trailing, 8)
          }

          VStack(alignment: .leading) {
            Text("\(info.bundleIdentifier): \(info.name)")
              .font(.title)
              .frame(maxWidth: .infinity, alignment: .leading)
              .multilineTextAlignment(.leading)
              .lineLimit(3)

            Spacer().frame(height: 8)

            Text("Last active time: \(info.date)")
              .font(.title3)
              .frame(maxWidth: .infinity, minHeight: 32, alignment: .leading)
              .multilineTextAlignment(.leading)
              .lineLimit(3)

            Spacer().frame(height: 8)

            Text("Total use time: \(self.formatter.string(from: info.totalUseTimeMs)!)")
              .font(.title3)
              .foregroundColor(.pink)
              .multilineTextAlignment(.leading)
              .lineLimit(1)
          }
        }
          .padding(8)
      }
    }.listStyle(.sidebar)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(viewModel: .init())
  }
}

private func durationFormatter() -> DateComponentsFormatter {
  let formatter = DateComponentsFormatter()
  formatter.allowedUnits = [.day, .hour, .minute, .second]
  formatter.unitsStyle = .abbreviated
  formatter.zeroFormattingBehavior = .pad
  return formatter
}

private class IconLoader {
  private let cacheImages = NSCache<NSString, NSImage>()

  init() {
    self.cacheImages.countLimit = 8
  }

  func icon(for app: FrontMostAppInfo) -> NSImage? {
    if let cached = cacheImages.object(forKey: app.bundleIdentifier as NSString) {
      return cached
    }

    let image = app.icon
    if let image = image {
      cacheImages.setObject(
        image,
        forKey: app.bundleIdentifier as NSString
      )
    }
    return image
  }
}
