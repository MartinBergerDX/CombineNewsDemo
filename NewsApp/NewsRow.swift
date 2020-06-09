//
//  NewsRow.swift
//  NewsApp
//
//  Created by Martin on 6/9/20.
//  Copyright © 2020 HeavyDebugging.inc. All rights reserved.
//

import Foundation
import SwiftUI

struct NewsRow: View {
    var story: Story

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(story.title)
                    .font(.headline)
                    .foregroundColor(.orange)
                Spacer()
            }
            HStack {
                Text("By:")
                    .font(.subheadline)
                Text(story.by)
                    .font(.subheadline)
                Spacer()
            }
        }
    }
}

struct NewsRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NewsRow(story: Story(id: 0, title: "Test1", by: "Author", time: TimeInterval.init(), url: "URL String"))
            NewsRow(story: Story(id: 0, title: "Test2", by: "Author", time: TimeInterval.init(), url: "URL String"))
        }
    }
}
