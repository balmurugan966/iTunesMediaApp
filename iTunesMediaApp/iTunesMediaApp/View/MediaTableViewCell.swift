//
//  MediaTableViewCell.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 21/12/24.
//
import UIKit
import Foundation

class MediaTableViewCell: UITableViewCell {
    
    // Rename the custom image view to avoid conflict
    internal let customImageView = UIImageView()
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        customImageView.contentMode = .scaleToFill
        contentView.addSubview(customImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        titleLabel.textColor = .white
        // Set up constraints for the imageView, titleLabel, and artistLabel
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add a configure method to set up the content for this cell
    func configure(with mediaItem: MediaItem) {
        titleLabel.text = mediaItem.trackName ?? mediaItem.collectionName
        artistLabel.text = mediaItem.artistName
        if let urlString = mediaItem.artworkUrl100, let url = URL(string: urlString) {
            customImageView.load(url: url) // Assuming you have an image loading function like the one shown earlier
        }
    }
    
    private func setupConstraints() {
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Rectangular image view
            customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            customImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customImageView.widthAnchor.constraint(equalToConstant: 100),
            customImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Title label
            titleLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10), // Top padding
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // Artist label
            artistLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 10),
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            artistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            artistLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10) // Bottom padding
        ])
    }


}
