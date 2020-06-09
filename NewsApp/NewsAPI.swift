//
//  NewsAPI.swift
//  NewsApp
//
//  Created by Martin on 6/9/20.
//  Copyright © 2020 HeavyDebugging.inc. All rights reserved.
//

import Foundation
import Combine

struct API {
    /// API Errors.
    enum Error2: LocalizedError {
        case addressUnreachable(URL)
        case invalidResponse
        
        var errorDescription: String? {
            switch self {
            case .invalidResponse: return "The server responded with garbage."
            case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
            }
        }
    }
    
    /// API endpoints.
    enum EndPoint {
        static let baseURL = URL(string: "https://hacker-news.firebaseio.com/v0/")!
        
        case stories
        case story(Int)
        
        var url: URL {
            switch self {
            case .stories:
                return EndPoint.baseURL.appendingPathComponent("newstories.json")
            case .story(let id):
                return EndPoint.baseURL.appendingPathComponent("item/\(id).json")
            }
        }
    }
    
    /// Maximum number of stories to fetch (reduce for lower API strain during development).
    var maxStories = 10
    
    /// A shared JSON decoder to use in calls.
    private let decoder = JSONDecoder()
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
    
    func story(id: Int) -> AnyPublisher<Story, Error2> {
        return URLSession.shared.dataTaskPublisher(for: EndPoint.story(id).url)
            .receive(on: apiQueue)
            .map(\.data)
            .decode(type: Story.self, decoder: decoder)
            .catch { _ in
                return Empty<Story, Error2>()
            }
            .eraseToAnyPublisher()
    }
    
    func mergedStories(ids storyIDs: [Int]) -> AnyPublisher<Story, Error2> {
        let storyIDs = Array(storyIDs.prefix(maxStories))
        precondition(!storyIDs.isEmpty)
        
        let initialPublisher = story(id: storyIDs[0])
        let remainder = Array(storyIDs.dropFirst())
        
        return remainder.reduce(initialPublisher) { combined, id in
            return combined
                .merge(with: story(id: id))
                .eraseToAnyPublisher()
        }
    }
    
    func stories() -> AnyPublisher<[Story], Error2> {
        URLSession.shared
            .dataTaskPublisher(for: EndPoint.stories.url)
            .map(\.data)
            .decode(type: [Int].self, decoder: decoder)
            .mapError { (error: Error) -> API.Error2 in
                switch error {
                case is URLError:
                    return Error2.addressUnreachable(EndPoint.stories.url)
                default:
                    return Error2.invalidResponse
                }
            }
            .filter { !$0.isEmpty }
            .flatMap { storyIDs in
                return self.mergedStories(ids: storyIDs)
            }
            .scan([]) { stories, story -> [Story] in
                return stories + [story]
            }
            .map { $0.sorted() }
            .eraseToAnyPublisher()
            
        //return Empty().eraseToAnyPublisher()
    }
}
