//
//  Topic.swift
//  Contentful
//
//  Created by Jey Starratt on 8/10/24.
//

/// Basic statistics for a particular topic.
struct Topic: Codable {
    /// Unique identifier.
    let id: UInt?

    /// The number of "yes" votes for this topic.
    let yesSum: Int?

    /// The number of "no" votes for this topic.
    let noSum: Int?

    /// Any overall comment about the topic.
    let comment: String?

    /// Description of the topic.
    let metadata: TopicMetadata?

    enum CodingKeys: String, CodingKey {
        case id = "topicItemId"
        case yesSum, noSum, comment
        case metadata = "topic"
    }
}

/// Descriptive information about the topic.
struct TopicMetadata: Codable {
    private struct TopicCategory: Codable {
        let name: String?
    }

    /// Unique identifier.
    let id: UInt

    /// User-friendly name for the topic.
    let name: String?

    /// If this topic could be a spoiler.
    let isSpoiler: Bool?

    /// If this topic is sensitive.
    let isSensitive: Bool?

    /// The raw category of the topic.
    private let topicCategory: TopicCategory?

    enum CodingKeys: String, CodingKey {
        case id, name, isSpoiler, isSensitive
        case topicCategory = "TopicCategory"
    }

    /// The category of the topic.
    var category: String? {
        topicCategory?.name
    }
}
