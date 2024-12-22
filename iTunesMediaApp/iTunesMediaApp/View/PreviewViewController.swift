//
//  PreviewViewController.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 22/12/24.
//

import UIKit
import SafariServices

class PreviewViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()
    private let descriptionLabel = UILabel() // New label for description
    private let previewButton = UIButton(type: .system)
    private var mediaItem: MediaItem
    
    // Initialize with a media item
    init(mediaItem: MediaItem) {
        self.mediaItem = mediaItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the UI
        view.backgroundColor = .black
        
        setupImageView()
        setupTitleLabel()
        setupArtistLabel()
        setupDescriptionLabel() // Setup description label
        setupPreviewButton()
        
        // Populate labels and image
        titleLabel.text = mediaItem.trackName ?? mediaItem.collectionName
        artistLabel.text = mediaItem.artistName
        descriptionLabel.text = "Description: \(mediaItem.collectionName ?? "No description available")" // Example description
        
        if let urlString = mediaItem.artworkUrl100, let url = URL(string: urlString) {
            imageView.load(url: url) // Assuming you have an image loading function like the one shown earlier
        }
    }
    
    // Set up the ImageView for displaying artwork
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // Set up the title label
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white // White text color for contrast against black background
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // Set up the artist label
    private func setupArtistLabel() {
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.textColor = .lightGray
        artistLabel.font = UIFont.systemFont(ofSize: 16)
        artistLabel.numberOfLines = 0
        artistLabel.textAlignment = .center
        view.addSubview(artistLabel)
        
        NSLayoutConstraint.activate([
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            artistLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            artistLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // Set up the description label
    private func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .white // White text color for contrast
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // Set up the preview button
    private func setupPreviewButton() {
        previewButton.translatesAutoresizingMaskIntoConstraints = false
        previewButton.setTitle("Preview in Safari", for: .normal)
        previewButton.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
        previewButton.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(previewButton)
        
        NSLayoutConstraint.activate([
            previewButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            previewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // Action for preview button tap
    @objc private func previewButtonTapped() {
        if let urlString = mediaItem.collectionViewUrl, let url = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
}
