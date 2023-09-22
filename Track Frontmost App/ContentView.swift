//
//  ContentView.swift
//  Track Frontmost App
//
//  Created by Hoc Nguyen T. on 9/22/23.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject
  var viewModel: FrontMostAppInfoViewModel

  var body: some View {
    List {
      ForEach(viewModel.infos) { info in
        VStack(alignment: .leading) {
          Text("\(info.bundleIdentifier): \(info.name)")
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .lineLimit(3)

          Spacer().frame(height: 8)

          Text("\(info.date)")
            .font(.title3)
            .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
            .multilineTextAlignment(.leading)
            .lineLimit(3)
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
