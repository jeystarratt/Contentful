//
//  YesNoBox.swift
//  Contentful
//
//  Created by Jey Starratt on 8/10/24.
//

import SwiftUI

/// Displays a comparison between "yes" and "no" counts.
struct YesNoBox: View {
    /// Number of "yes" for this topic.
    let yesCount: Int?

    /// Number of "no" for this topic.
    let noCount: Int?

    var body: some View {
        if let yesCount, let noCount {
            HStack(spacing: 0) {
                VStack {
                    Text("YES")
                    Text(String(yesCount))
                        .font(.callout)
                }
                .bold(yesCount > noCount)
                .padding(4)
                .background(Color.red.opacity(yesCount > noCount ? 1 : 0.25))
                VStack {
                    Text("NO")
                    Text(String(noCount))
                        .font(.callout)
                }
                .bold(noCount >= yesCount)
                .padding(4)
                .background(Color.green.opacity(noCount >= yesCount ? 1 : 0.25))
            }
        }
    }
}
