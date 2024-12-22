//
//  MediaServiceProtocol.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 22/12/24.
//

import Combine

protocol MediaServiceProtocol {
    func fetchMedia(searchTerm: String, mediaType: [MediaType]) -> AnyPublisher<[MediaItem], Error>
}

