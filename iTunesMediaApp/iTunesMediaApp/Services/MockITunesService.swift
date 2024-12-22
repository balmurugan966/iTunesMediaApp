//
//  MockITunesService.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 22/12/24.
//

import Foundation
import Combine

class MockITunesService: MediaServiceProtocol {
    var shouldReturnError: Bool
    var shouldReturnEmptyResponse: Bool

    // Custom initializer with default values for parameters
    init(shouldReturnError: Bool = false, shouldReturnEmptyResponse: Bool = false) {
        self.shouldReturnError = shouldReturnError
        self.shouldReturnEmptyResponse = shouldReturnEmptyResponse
    }

    func fetchMedia(searchTerm: String, mediaType: [MediaType]) -> AnyPublisher<[MediaItem], Error> {
        if shouldReturnError {
            // Simulate a network failure or error
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network Error"])
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        if shouldReturnEmptyResponse {
            // Return an empty array of media items
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        // Load mock data from the "MockMediaResponse.json" file
        guard let url = Bundle.main.url(forResource: "MockMediaResponse", withExtension: "json") else {
            return Fail(error: NSError(domain: "MockITunesServiceError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock data file not found."]))
                .eraseToAnyPublisher()
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(MediaResponse.self, from: data)
            return Just(response.results)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NSError(domain: "MockITunesServiceError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode mock data."]))
                .eraseToAnyPublisher()
        }
    }
}
