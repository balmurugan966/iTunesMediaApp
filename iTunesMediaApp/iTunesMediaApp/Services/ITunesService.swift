//
//  ITunesService.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 21/12/24.
//

import Foundation
import Combine

class ITunesService: MediaServiceProtocol {
    private let baseURL = "https://itunes.apple.com/search"
    private var cancellables: Set<AnyCancellable> = []
    private let session: URLSession
    
    // Modify the initializer to accept a custom session for testing
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetchMedia(searchTerm: String, mediaType: [MediaType]) -> AnyPublisher<[MediaItem], Error> {
        guard var components = URLComponents(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let mediaTypes = mediaType.map { $0.rawValue }
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "term", value: searchTerm)
        ]
        mediaTypes.forEach { type in
            queryItems.append(URLQueryItem(name: "entity", value: type))
        }
        
        components.queryItems = queryItems

        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MediaResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
