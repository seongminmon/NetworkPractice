//
//  Movie.swift
//  NetworkPractice
//
//  Created by 김성민 on 6/12/24.
//

import UIKit

struct MovieResponse: Decodable {
    let page: Int
    var results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let overview: String
    let genreIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
    }
    
    static let genreDict: [Int: String] = [
        28: "Action",
        12: "Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        14: "Fantasy",
        36: "History",
        27: "Horror",
        10402: "Music",
        9648: "Mystery",
        10749: "Romance",
        878: "Science Fiction",
        10770: "TV Movie",
        53: "Thriller",
        10752: "War",
        37: "Western",
    ]
    
    var genreText: String {
        var ret = ""
        for genreId in genreIds {
            if let genre = Movie.genreDict[genreId] {
                ret += "#\(genre) "
            }
        }
        return ret
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = formatter.date(from: releaseDate)!
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    var posterImageURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath ?? "")")
    }
    
    var backdropImageURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500/\(backdropPath ?? "")")
    }
    
    var score: String {
        return String(format: "%.1f", voteAverage)
    }
}
