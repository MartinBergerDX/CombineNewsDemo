//
//  StoryViewModel.swift
//  NewsApp
//
//  Created by Martin on 6/9/20.
//  Copyright © 2020 HeavyDebugging.inc. All rights reserved.
//

import Foundation
import Combine

class StoryViewModel: ObservableObject {
    @Published var stories: [Story] = []
    var subscriptions = Set<AnyCancellable>()
    
    func load() {
        let api = API()
        api.stories()
            .receive(on: DispatchQueue.main)
            .catch { _ in Empty() }
            .assign(to: \.stories, on: self)
            .store(in: &subscriptions)
    }
}

class DemoStoryViewModel: StoryViewModel {
    override func load() {
        stories = [
            Story(id: 0, title: "Test1", by: "Author", time: TimeInterval.init(), url: "URL String"),
            Story(id: 1, title: "Test2", by: "Author", time: TimeInterval.init(), url: "URL String"),
            Story(id: 2, title: "Test3", by: "Author", time: TimeInterval.init(), url: "URL String"),
            Story(id: 3, title: "Test4", by: "Author", time: TimeInterval.init(), url: "URL String")]
    }
}
