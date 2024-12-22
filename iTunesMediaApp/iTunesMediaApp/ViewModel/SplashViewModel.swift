//
//  SplashViewModel.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 22/12/24.
//

import Combine

class SplashViewModel {
    private let rootDetectionService: RootDetection
    @Published var isRooted: Bool = false

    init(rootDetectionService: RootDetection) {
        self.rootDetectionService = rootDetectionService
    }

    func checkForRootStatus() {
        isRooted = rootDetectionService.isDeviceRooted()
    }
}
