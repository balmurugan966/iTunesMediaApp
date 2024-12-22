//
//  ITunesServiceIntegrationTests.swift
//  iTunesMediaAppTests
//
//  Created by balamuruganc on 22/12/24.
//

import XCTest
import Combine
@testable import iTunesMediaApp

final class ITunesServiceIntegrationTests: XCTestCase {
    var viewModel: MediaViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        // Initialize the real ITunesService
        let session = URLSession.shared
        let realService = ITunesService(session: session)
        viewModel = MediaViewModel(mediaService: realService)
    }

    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testSearchMedia_withRealAPI() {
        // Use real API for this test
        viewModel.term = "bala"
        viewModel.selectedMediaTypes = [.album]

        let expectation = self.expectation(description: "Search Media from Real API")

        viewModel.searchMedia(term: viewModel.term) {
            // Check that real API returns data (make sure to use a valid search term)
            XCTAssertTrue(self.viewModel.mediaItems.count > 0)
            XCTAssertNotNil(self.viewModel.mediaItems[0].artistName)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testSearchMedia_withRealAPI_ErrorHandling() {
        // Simulate an invalid term that should result in an error
        viewModel.term = "invalidtermthatshouldfail"
        viewModel.selectedMediaTypes = [.album]

        let expectation = self.expectation(description: "Service Failure from Real API")

        viewModel.searchMedia(term: viewModel.term) {
            // Check that no media items are returned for an invalid search term
            XCTAssertEqual(self.viewModel.mediaItems.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
