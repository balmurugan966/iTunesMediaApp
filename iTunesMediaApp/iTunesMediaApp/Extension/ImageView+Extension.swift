//
//  ImageView+Extension.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 21/12/24.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        // Perform the request asynchronously on a background thread
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Use URLSession to fetch the image data asynchronously
            URLSession.shared.dataTask(with: url) { data, response, error in
                // If there was an error or no data, exit early
                guard let data = data, error == nil else { return }
                
                // Switch back to the main thread to update the UI
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self?.image = image
                    }
                }
            }.resume() // Start the data task
        }
    }
}

