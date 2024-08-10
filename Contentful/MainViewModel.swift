//
//  MainViewModel.swift
//  Contentful
//
//  Created by Jey Starratt on 8/10/24.
//

import SwiftUI
import Combine

extension MainView {
    // Not using @Observable since we want debounce, etc.
    @MainActor
    class ViewModel: ObservableObject {
        /// Raw search term provided immediately.
        @Published var searchTerm: String = ""

        /// Search term (delayed) to provide to the API.
        @Published var debouncedSearchTerm: String = ""

        /// Results from the API.
        @Published var results: [MediaItem]?

        /// Whether we are loading results.
        @Published var loading = false

        /// If any errors were encountered.
        @Published var error: ContentfulError?

        private var bag = Set<AnyCancellable>()

        init() {
            $searchTerm
                .removeDuplicates()
                .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
                .sink(receiveValue: { [weak self] value in
                    self?.debouncedSearchTerm = value
                })
                .store(in: &bag)
        }

        func search() async {
            loading = true
            error = nil

            do {
                results = try await DoesTheDogDieService.shared.search(term: searchTerm).items
            } catch {
                guard let underlyingError = error as? ContentfulError else {
                    self.error = ContentfulError.failedSearch
                    return
                }

                self.error = underlyingError
            }

            loading = false
        }
    }
}

