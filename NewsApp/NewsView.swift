//
//  ContentView.swift
//  NewsApp
//
//  Created by Martin on 6/9/20.
//  Copyright © 2020 HeavyDebugging.inc. All rights reserved.
//

import SwiftUI

struct NewsView: View {
    @ObservedObject var viewModel = StoryViewModel()
    var body: some View {
        List {
            ForEach(viewModel.stories) { story in
                NewsRow(story: story)
            }
            
        }
        .listRowInsets(EdgeInsets())
        .onAppear {
            self.viewModel.load()
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
