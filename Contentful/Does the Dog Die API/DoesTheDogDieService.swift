//
//  DoesTheDogDieService.swift
//  Contentful
//
//  Created by Jey Starratt on 8/10/24.
//

import Foundation

/// Handles interactions with the Does the Dog Die API.
final class DoesTheDogDieService {
    static let shared = DoesTheDogDieService()

    func search(term: String) async throws -> SearchResults {
        try await process(path: "dddsearch?q=\(term)")
    }

    func media(id: UInt) async throws -> Media {
        try await process(path: "media/\(id)")
    }

    private func process<Result: Codable>(path: String) async throws -> Result {
        guard DoesTheDogDieAPIKey.isEmpty == false else {
            throw ContentfulError.needAPIKey
        }

        guard let url = URL(string: "https://www.doesthedogdie.com/\(path)") else {
            throw ContentfulError.badURL
        }

        var req = URLRequest(url: url)
        req.addValue(DoesTheDogDieAPIKey, forHTTPHeaderField: "X-API-KEY")
        req.addValue("application/json", forHTTPHeaderField: "Accept")

        if let (data, _) = try? await URLSession(configuration: .default).data(for: req) {
            return try JSONDecoder().decode(Result.self, from: data)
        }

        throw ContentfulError.badResponse
    }
}
