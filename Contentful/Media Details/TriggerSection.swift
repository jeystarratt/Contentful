//
//  TriggerSection.swift
//  Contentful
//
//  Created by Jey Starratt on 8/10/24.
//

import SwiftUI

/// An individual section listing topics under a trigger category.
struct TriggerSection: View {
    /// Trigger key to our topics grouping.
    let categoryKey: String

    /// Various topics in that category.
    let children: [Topic]

    /// Whether or not the category is expanded.
    @State private var isExpanded = false

    var body: some View {
        Section(isExpanded: $isExpanded, content: {
            ForEach(children, id: \.id) { topicStats in
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(topicStats.metadata?.name?.localizedCapitalized ?? "")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)

                        YesNoBox(yesCount: topicStats.yesSum, noCount: topicStats.noSum)
                    }

                    if let comment = topicStats.comment, comment.isEmpty == false {
                        Text(comment)
                    }
                }
                .padding(.bottom)
            }
        }, header: {
            HStack {
                Text(categoryKey)
                    .font(.title2)
                    .textCase(nil)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Group {
                    if isExpanded {
                        Image(systemName: "chevron.down")
                    } else {
                        Image(systemName: "chevron.right")
                    }
                }
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
            }
        })
    }
}
