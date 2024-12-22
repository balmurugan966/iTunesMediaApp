//
//  MockURLProtocol.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 22/12/24.
//

import Foundation

class MockURLProtocol: URLProtocol {
    // Static properties to store mock data, response, and errors
    static var mockData: Data?
    static var mockResponse: HTTPURLResponse?
    static var mockError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        // This method determines if the request should be intercepted by this mock protocol
        // Here we can intercept all requests or add logic to handle only specific ones
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // This method is called when the request is about to be sent, and the response is returned
        
        if let data = MockURLProtocol.mockData {
            // If mock response data exists, return it as a successful response
            let response = MockURLProtocol.mockResponse ?? HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            self.client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
        } else if let error = MockURLProtocol.mockError {
            // If mock response error exists, return the error
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            // If neither mock data nor mock error exists, we fail gracefully
            let error = NSError(domain: "MockURLProtocolError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock data or error not set"])
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        
        // Indicate that the request has finished loading
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // No additional work required for stopping the loading
    }
    
    // Helper function to load the JSON file from the bundle
    static func loadMockDataFromFile() -> Data? {
        guard let url = Bundle.main.url(forResource: "MockMediaResponse", withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error loading mock data: \(error.localizedDescription)")
            return nil
        }
    }
}
