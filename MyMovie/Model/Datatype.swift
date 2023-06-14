//
//  MovieMetadata.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/05/26.
//

import Foundation


//struct MovieMetadata: Codable, Hashable {
//    let id: UInt32
//    let genres: [Genre]
//    let overview: String?
//    let poster_path: String?
//    let title: String
//    let vote_average: Float
//    let vote_count: UInt32
//    let adult: Bool
//    let runtime: String
//    let release_date: String
//}


struct GenreJsonModel: Codable, Hashable {
    let id: UInt32
    let name: String
}

//var AllGenres: Set<Genre> = Set() // For collect all genres without any deplicates.

//struct Credit: Codable {
//    let id: UInt32
//    let cast: [Cast]
//}

struct CastJsonModel: Codable {
    let cast_id: UInt32
    let character: String
    let credit_id: String
    let id: UInt32
    let name: String
    let profile_path: String?
}

/*
 userId,movieId,rating,timestamp
 1,31,2.5,1260759144
 */
//struct Rating: Codable {
//    let user_id: UInt32
//    let movie_id: UInt32
//    let rating: Float
//    let timestamp: UInt64
//}
