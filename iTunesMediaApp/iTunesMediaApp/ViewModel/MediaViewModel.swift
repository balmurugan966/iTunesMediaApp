//
//  MediaViewModel.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 21/12/24.
//

import Combine

class MediaViewModel: ObservableObject {
    @Published var mediaItems: [MediaItem] = []
    @Published var error: Error?  // Holds the error
    var selectedMediaTypes: [MediaType] = []
    @Published var validationError: String? = nil
    @Published var term: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    var mediaService: MediaServiceProtocol
    
    // Initialize with dependency injection
    init(mediaService: MediaServiceProtocol) {
        self.mediaService = mediaService
    }
    
    func validateInput() {
        if term.isEmpty {
            validationError = "Please enter a search term."
        } else if selectedMediaTypes.isEmpty {
            validationError = "Please select at least one media type."
        } else {
            validationError = nil
        }
    }
    
    func searchMedia(term: String, completion: @escaping () -> Void) {
        mediaService.fetchMedia(searchTerm: term, mediaType: selectedMediaTypes)
            .sink(receiveCompletion: { completionResult in
                if case let .failure(error) = completionResult {
                    self.error = error
                }
            }, receiveValue: { [weak self] items in
                self?.mediaItems = items
                completion()
            })
            .store(in: &cancellables)
    }
}
