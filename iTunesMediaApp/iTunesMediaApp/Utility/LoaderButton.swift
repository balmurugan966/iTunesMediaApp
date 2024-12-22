//
//  LoaderButton.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 22/12/24.
//

import UIKit

class LoaderButton: UIButton {
    
    // UI Components
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let buttonLabel = UILabel()
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // Setup the button with activity indicator and label
    private func setupButton() {
        // Configure button style
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
        
        // Configure activity indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        activityIndicator.isHidden = true
        
        // Configure label
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.textColor = .white
        buttonLabel.textAlignment = .center
        buttonLabel.font = UIFont.systemFont(ofSize: 16)
        buttonLabel.text = "Submit" // Default text
        
        // Add subviews
        self.addSubview(activityIndicator)
        self.addSubview(buttonLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Center the label in the button
            buttonLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            // Position the activity indicator to the right of the label
            activityIndicator.leadingAnchor.constraint(equalTo: buttonLabel.trailingAnchor, constant: 10),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // Show or hide the loader with the text update
    func setLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            buttonLabel.text = "Loading..."
            self.isEnabled = false // Disable the button while loading
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            buttonLabel.text = "Submit"
            self.isEnabled = true // Re-enable the button
        }
    }
}
