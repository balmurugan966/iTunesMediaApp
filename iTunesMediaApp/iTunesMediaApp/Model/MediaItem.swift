//
//  MediaItem.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 21/12/24.
//

import Foundation

struct MediaItem: Decodable {
    let wrapperType: String?      // Media type (e.g., track, collection)
    let kind: String?             // Specific type (e.g., song, album)
    let trackName: String?        // Title of the media item
    let artistName: String?       // Artist/Author name
    let artworkUrl100: String?    // Artwork URL (100x100 image)
    let previewUrl: String?       // Preview URL for audio/video

    // Optional properties
    let collectionName: String?   // Collection/Album name
    let trackPrice: Double?       // Price of the track
    let currency: String?         // Currency (e.g., USD)
    let collectionViewUrl: String?
}


struct MediaResponse: Decodable {
    let results: [MediaItem]
}

enum MediaType: String, CaseIterable {
    case album = "album"
    case movie = "movie"
    case musicVideo = "musicVideo"
    case song = "musicTrack"
    case movieArtist = "movieArtist"  // New case for movie artist
    case ebook = "ebook"              // New case for ebook
    case podcast = "podcast"          // New case for podcast

    var displayName: String {
        switch self {
        case .album: return "Album"
        case .movie: return "Movie"
        case .musicVideo: return "Music Video"
        case .song: return "Song"
        case .movieArtist: return "Movie Artist"  // Display name for movie artist
        case .ebook: return "Ebook"               // Display name for ebook
        case .podcast: return "Podcast"           // Display name for podcast
        }
    }
}

