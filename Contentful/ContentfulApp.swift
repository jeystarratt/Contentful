//
//  ContentfulApp.swift
//  Contentful
//
//  Created by Jey Starratt on 8/10/24.
//

import SwiftUI

@main
struct ContentfulApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: MediaItem.self)
    }
}
