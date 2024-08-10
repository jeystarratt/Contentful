//
//  MediaRow.swift
//  Contentful
//
//  Created by Jey Starratt on 8/10/24.
//

import SwiftUI

/// A single row for a search result.
struct MediaRow: View {
    let media: MediaItem

    var body: some View {
        HStack {
            Poster(url: media.artURL, type: media.type)

            VStack(alignment: .leading) {
                Text(media.name)

                if metadata(for: media).isEmpty == false {
                    Text(metadata(for: media))
                }
            }
        }
    }

    private func metadata(for result: MediaItem) -> String {
        [result.type.rawValue, result.releaseYear]
            .compactMap({ $0 })
            .joined(separator: " • ")
    }
}
