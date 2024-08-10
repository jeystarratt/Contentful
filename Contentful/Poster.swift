//
//  Poster.swift
//  Contentful
//
//  Created by Jey Starratt on 8/10/24.
//

import SwiftUI

/// Loads a provided URL with contextual placeholders.
struct Poster: View {
    let url: URL?

    let type: MediaType

    var body: some View {
        if let url {
            AsyncImage(url: url, content: { image in
                image
                    .resizable(resizingMode: .stretch)
                    .frame(width: 100, height: 150)
            }, placeholder: {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundStyle(Color.gray)
                    .frame(width: 100, height: 150)
            })
        } else {
            Group {
                switch type {
                case .movie:
                    Image(systemName: "movieclapper")
                case .tvShow:
                    Image(systemName: "tv")
                case .unknown:
                    Image(systemName: "play.rectangle")
                }
            }
            .frame(width: 100, height: 150)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundStyle(Color.gray)
            }
        }
    }
}
