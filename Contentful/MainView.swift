//
//  MainView.swift
//  Contentful
//
//  Created by Jey Starratt on 8/10/24.
//

import SwiftUI
import SwiftData

/// The initial "home" view of the app.
struct MainView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            ContentfulBody(viewModel: viewModel)
                .navigationTitle("Contentful")
        }
        .searchable(text: $viewModel.searchTerm, prompt: "Search for a title...")
        .onChange(of: viewModel.debouncedSearchTerm) { _, _ in
            search()
        }
        .onSubmit(of: .search, search)
    }

    private func search() {
        Task { await viewModel.search() }
    }
}

/// The inner body of the MainView.
private struct ContentfulBody: View {
    @ObservedObject var viewModel: MainView.ViewModel

    @Environment(\.isSearching) var isSearching

    @Query var starred: [MediaItem]

    var body: some View {
        Group {
            // TODO: Consider a ViewState-like enum.
            if let error = viewModel.error {
                error.errorDescription
            } else if isSearching {
                List {
                    ForEach(viewModel.results ?? []) { result in
                        NavigationLink {
                            MediaView(mediaID: result.id)
                        } label: {
                            MediaRow(media: result)
                        }
                    }
                }
            } else {
                if starred.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "sparkles.tv")
                            .font(.largeTitle)
                            .frame(alignment: .center)

                        Text("Be content with your media content")
                    }
                } else {
                    List {
                        Section {
                            ForEach(starred.sorted(
                                by: { $0.name.localizedStandardCompare($1.name) == .orderedAscending })) { item in
                                    NavigationLink {
                                        MediaView(mediaID: item.id)
                                    } label: {
                                        MediaRow(media: item)
                                    }
                                }
                        } header: {
                            Text("Starred ⭐️")
                                .textCase(nil)
                                .font(.title2)
                        }
                    }
                }
            }
        }
    }
}
