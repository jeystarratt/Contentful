//
//  Media.swift
//  Contentful
//
//  Created by Jey Starratt on 8/10/24.
//

import Foundation
import SwiftData

/// Results from a "Does the Dog Die" search.
struct SearchResults: Codable {
    let items: [MediaItem]
}

/// All data about a particular piece of entertainment.
struct Media: Codable {
    let item: MediaItem

    let topicItemStats: [Topic]
}

/// What kind of media is this?
enum MediaType: String, Codable {
    case tvShow = "TV Show"
    case movie = "Movie"
    case unknown
}

@Model
/// Metadata about the piece of media.
class MediaItem: Codable, Identifiable {
    /// Intermediate representation of the type.
    private struct ItemType: Codable {
        let id: UInt
        let name: String?
    }

    /// Unique identifier.
    let id: UInt

    /// User-friendly name.
    let name: String

    /// Raw genre of the media.
    let genre: String?

    /// Year of public release.
    let releaseYear: String?

    /// Stringly-typed URL for a general use thumbnail.
    private let art: String?

    /// Stringly-typed URL for a background image.
    private let backgroundImage: String?

    /// Stringly-typed URL for a poster image.
    private let posterImage: String?

    /// General summary of the media.
    let overview: String?

    /// Stringly-typed category of the media.
    private let itemType: ItemType?

    /// URL for a general use thumbnail.
    var artURL: URL? {
        if let art {
            return URL(string: art)
        }
        guard let image = posterImage ?? backgroundImage else { return nil }
        return URL(string: "https://www.doesthedogdie.com/content/200/0/\(image)")
    }

    /// Category of the media.
    var type: MediaType {
        guard let name = itemType?.name else { return .unknown }
        return MediaType(rawValue: name) ?? .unknown
    }

    enum CodingKeys: CodingKey {
        case id
        case name
        case genre
        case releaseYear
        case art
        case backgroundImage
        case posterImage
        case overview
        case itemType
    }

    private init(id: UInt, name: String, genre: String?, releaseYear: String?, art: String?, backgroundImage: String?, posterImage: String?, overview: String?, itemType: ItemType?) {
        self.id = id
        self.name = name
        self.genre = genre
        self.releaseYear = releaseYear
        self.art = art
        self.backgroundImage = backgroundImage
        self.posterImage = posterImage
        self.overview = overview
        self.itemType = itemType
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UInt.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        genre = try? container.decode(String.self, forKey: .genre)
        releaseYear = try? container.decode(String.self, forKey: .releaseYear)
        art = try? container.decode(String.self, forKey: .art)
        backgroundImage = try? container.decode(String.self, forKey: .backgroundImage)
        posterImage = try? container.decode(String.self, forKey: .posterImage)
        overview = try? container.decode(String.self, forKey: .overview)
        itemType = try? container.decode(ItemType.self, forKey: .itemType)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try? container.encode(genre, forKey: .genre)
        try? container.encode(releaseYear, forKey: .releaseYear)
        try? container.encode(art, forKey: .art)
        try? container.encode(backgroundImage, forKey: .backgroundImage)
        try? container.encode(posterImage, forKey: .posterImage)
        try? container.encode(overview, forKey: .overview)
        try? container.encode(itemType, forKey: .itemType)
    }
}
