//
//  MediaViewModelTests.swift
//  iTunesMediaAppTests
//
//  Created by balamuruganc on 22/12/24.
//

import XCTest
import Combine
@testable import iTunesMediaApp

final class MediaViewModelTests: XCTestCase {
    var viewModel: MediaViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        
        // Inject MockITunesService into the view model
        let mockService = MockITunesService()
        viewModel = MediaViewModel(mediaService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testSearchMedia() {
        // Prepare the mock data
        viewModel.term = "test"
        viewModel.selectedMediaTypes = [.album]
        
        let expectation = self.expectation(description: "Search Media")
        
        // Perform the search
        viewModel.searchMedia(term: viewModel.term) {
            XCTAssertEqual(self.viewModel.mediaItems.count, 2)
            XCTAssertEqual(self.viewModel.mediaItems[0].artistName, "Artist One")
            XCTAssertEqual(self.viewModel.mediaItems[1].artistName, "Artist Two")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // Negative test: Empty search term
    func testSearchMedia_withEmptyTerm() {
        viewModel.term = ""
        viewModel.selectedMediaTypes = [.album]
        
        // Validate input
        viewModel.validateInput()
        
        // Expect validation error for empty term
        XCTAssertNotNil(viewModel.validationError)
        XCTAssertEqual(viewModel.validationError, "Please enter a search term.")
    }
    
    // Negative test: No media types selected
    func testSearchMedia_withNoMediaTypes() {
        viewModel.term = "test"
        viewModel.selectedMediaTypes = []
        
        // Validate input
        viewModel.validateInput()
        
        // Expect validation error for no media types selected
        XCTAssertNotNil(viewModel.validationError)
        XCTAssertEqual(viewModel.validationError, "Please select at least one media type.")
    }
    // Test: Empty response from service (no results)
    func testSearchMedia_emptyResponse() {
        // Simulate an empty response
        let mockServiceWithEmptyResponse = MockITunesService(shouldReturnEmptyResponse: true)
        viewModel = MediaViewModel(mediaService: mockServiceWithEmptyResponse)
        
        viewModel.term = "test"
        viewModel.selectedMediaTypes = [.album]
        
        let expectation = self.expectation(description: "Empty Response")
        
        // Perform the search
        viewModel.searchMedia(term: viewModel.term) {
            XCTAssertEqual(self.viewModel.mediaItems.count, 0)
            XCTAssertNil(self.viewModel.error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
