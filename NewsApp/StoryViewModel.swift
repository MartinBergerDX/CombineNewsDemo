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
