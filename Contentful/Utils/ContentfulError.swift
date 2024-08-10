//
//  ContentfulError.swift
//  Contentful
//
//  Created by Jey Starratt on 8/10/24.
//

import SwiftUI

/// General purpose errors from "Does the Dog Die" API.
enum ContentfulError: Error {
    /// A response we didn't anticipate.
    case badResponse

    /// A URL we weren't expecting to be formed.
    case badURL

    /// General search failure.
    case failedSearch

    /// Double-check API key is in the necessary file.
    case needAPIKey

    var errorDescription: Text {
        switch self {
        case .badResponse:
            return Text("Encountered a bad response.")
        case .badURL:
            return Text("Encountered a bad URL.")
        case .failedSearch:
            return Text("Failed to retrieve search results.")
        case .needAPIKey:
            return Text("API Key is needed. Check `DoesTheDogDieAPIKey`.")
        }
    }
}

