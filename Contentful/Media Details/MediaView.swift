//
//  MediaView.swift
//  Contentful
//
//  Created by Jey Starratt on 8/10/24.
//

import SwiftUI
import SwiftData

/// The individual view for a piece of media.
struct MediaView: View {
    @Environment(\.modelContext) var modelContext

    /// Details for the specific media.
    @State private var media: Media?

    /// Organized grouping of various topics.
    @State private var categories: [String: [Topic]] = [:]

    /// Whether we are loading additional media information.
    @State private var loading = true

    /// If we encountered any errors along the way.
    @State private var error: Error?

    // TODO: Resolve this.
    /// A bit of a workaround to enforce UI updates.
    @State private var uuid = UUID()

    /// ID of the media we are fetching.
    let mediaID: UInt

    /// Whether or not the media has been starred.
    private var isStarred: Bool {
        guard let mediaItem = media?.item else { return false }
        var descriptor = FetchDescriptor<MediaItem>(predicate: #Predicate { $0.id == mediaItem.id })
        descriptor.includePendingChanges = true
        return (try? modelContext.fetchCount(descriptor)) ?? 0 > 0
    }

    /// Media "summary."
    private var metadata: String {
        [media?.item.type.rawValue, media?.item.releaseYear, media?.item.genre?.localizedCapitalized]
            .compactMap({ $0 })
            .joined(separator: " • ")
    }

    var body: some View {
        Group {
            if let error {
                // TODO: More meaningful error messaging.
                Text(error.localizedDescription)
            } else if loading {
                ProgressView()
            } else if let media {
                List {
                    HStack {
                        Spacer()

                        Poster(url: media.item.artURL, type: media.item.type)

                        Spacer()
                    }

                    LabeledContent("Name", value: media.item.name)
                    LabeledContent("Type", value: metadata)

                    if let overview = media.item.overview {
                        VStack(alignment: .leading) {
                            Text("Overview")

                            Text(overview)
                                .foregroundStyle(.secondary)
                        }
                    }

                    ForEach(categories.keys.sorted(
                        by: { $0.localizedStandardCompare($1) == .orderedAscending }), id: \.self) { categoryKey in
                            if let children = categories[categoryKey] {
                                TriggerSection(categoryKey: categoryKey, children: children)
                            }
                        }
                }
            }
        }
        .task {
            loading = true

            do {
                media = try await DoesTheDogDieService.shared.media(id: mediaID)
                processCategories()
            } catch {
                self.error = error
            }

            loading = false
        }
        .toolbar {
            if let mediaItem = media?.item {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Star", systemImage: isStarred ? "star.fill" : "star") {
                        if isStarred {
                            try? modelContext.delete(model: MediaItem.self, where: #Predicate<MediaItem> { $0.id == mediaItem.id }, includeSubclasses: true)
                        } else {
                            modelContext.insert(mediaItem)
                        }
                        // Unfortunate workaround to ensure UI updates on model context changes.
                        uuid = UUID()
                    }
                }
            }
        }
        .id(uuid)
    }

    /// Updates categories on load.
    private func processCategories() {
        categories = Dictionary(grouping: media?.topicItemStats ?? []) {
            $0.metadata?.category ?? ""
        }
    }
}
