//
//  MockDataHelper.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 22/12/24.
//

import Foundation

func configureMockURLSession() {
    // Register the Mock URL Protocol for interception
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    
    // Set the mock session
    let mockSession = URLSession(configuration: config)
    
    // Load mock data from the file
    if let mockJSONData = MockURLProtocol.loadMockDataFromFile() {
        MockURLProtocol.mockData = mockJSONData
    } else {
        print("Failed to load mock data from file.")
    }
    
    // Set a mock response
    MockURLProtocol.mockResponse = HTTPURLResponse(
        url: URL(string: "https://itunes.apple.com/search")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )
    
    // Optionally, simulate an error (set to `nil` to disable errors)
    MockURLProtocol.mockError = nil
    
    // You can now use `mockSession` in your service or view model
    // service = YourService(session: mockSession)
}
