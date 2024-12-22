//
//  MediaCollectionViewCell.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 21/12/24.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    
    internal let customImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customImageView.contentMode = .scaleToFill
        contentView.addSubview(customImageView)
        contentView.addSubview(titleLabel)
        
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        customImageView.contentMode = .scaleAspectFill
        customImageView.clipsToBounds = true
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        // Add constraints
        NSLayoutConstraint.activate([
            customImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor), // Make it square
            
            titleLabel.topAnchor.constraint(equalTo: customImageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with mediaItem: MediaItem) {
        titleLabel.text = mediaItem.trackName ?? mediaItem.collectionName
        if let urlString = mediaItem.artworkUrl100, let url = URL(string: urlString) {
            customImageView.load(url: url) // Use your custom image loader or library
        }
    }
}

