//
//  CSVHelper.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/05/26.
//

import SwiftCSV
import Foundation
import UIKit

class CSVHelper {
    private static let decoder = JSONDecoder()
    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    public static func initializeRatings() {
        print("initialize Ratings")
        let path = Bundle.main.path(forResource: "ratings_small", ofType: ".csv", inDirectory: "DataSet")
        
        let url = URL(filePath: path!)
        
        do {
            print("before load csv")
            let csv = try CSV<Named>(url: url)
            print("before enumerate")
            csv.rows.enumerated().forEach { index, row in
                print("ratings: \(index) / \(csv.rows.count)")
                //                self.ratings!.append(
                //                    Rating(
                //                        user_id: UInt32(row["userId"] ?? "0")!,
                //                        movie_id: UInt32(row["movieId"] ?? "0")!,
                //                        rating: Float(row["rating"] ?? "0.0")!,
                //                        timestamp: UInt64(row["timestamp"] ?? "0")!
                //                    )
                //                )
                let rating = Rating(context: context)
                rating.user_id = Int32(row["userId"] ?? "0")!
                rating.rating = Float(row["rating"] ?? "0.0")!
                rating.timestamp = Int64(row["timestamp"] ?? "0")!
                // should find movie object before set
                if let midString = row["movieId"],
                   let movieId = Int(midString) {
                    var movies = try! context.fetch(MovieMetadata.fetchRequest())
                    movies = movies.filter { $0.movie_id == movieId }
                    if movies.count > 0 {
                        print("found movie id: \(movieId)")
                        rating.movie = movies[0]
                    }
                } else {
                    print("cannot parse movie id: \(row["movieId"])")
                }
            }
        } catch {
            fatalError("Error to convert CSV file: \(error)")
        }
        
        if context.hasChanges {
            try! context.save()
            print("saved ratings.")
        }
    }
    
    
    public static func initializeCredits() {
        print("initialize Credits")
        let path = Bundle.main.path(forResource: "credits", ofType: ".csv", inDirectory: "DataSet")
        
        let url = URL(filePath: path!)
        
        do {
            let csv = try CSV<Named>(url: url)
            
            for row in csv.rows {
                var castsJsonMoel: [CastJsonModel] = []
                
                // Convert json to hashable model.
                do {
                    guard var jsonString = row["cast"] else {
                        fatalError("Error to convert row column to string.")
                    }
                    jsonString = jsonString.replacingOccurrences(of: "'", with: "\"")
                    jsonString = jsonString.replacingOccurrences(of: "None", with: "null")
                    guard let jsonData = jsonString.data(using: .utf8) else {
                        fatalError("Error to convert json string to data.")
                    }
//                    print("before converting cast json")
                    let json: [CastJsonModel] = try self.decoder.decode([CastJsonModel].self, from: jsonData)
                    print("cast counts: \(json.count)")
                    castsJsonMoel = json
                } catch {
                    // print("Error to convert JSON: \(error)")
                }
                
                let credit = Credit(context: context)
                let movies = try! context.fetch(MovieMetadata.fetchRequest())
                let movie = movies.filter { $0.movie_id == Int32(row["id"]!)! }
                if !movie.isEmpty {
                    print("found movie: \(movie[0].title)")
                    credit.movie = movie[0]
                }
                
                let casts: [Cast] = try! context.fetch(Cast.fetchRequest())
                for castJsonModel in castsJsonMoel {
                    print("searching cast by id...")
                    let searchedCasts = casts.filter({ c in c.cast_id == castJsonModel.cast_id })
                    if searchedCasts.isEmpty {
                        let c = Cast(context: context)
                        c.cast_id = Int32(castJsonModel.cast_id)
                        c.character = castJsonModel.character
                        c.name = castJsonModel.name
                        c.profile_path = castJsonModel.profile_path
                        c.credits = NSSet(array: [credit])
                        print("new cast created: \(c.name)")
                    } else if searchedCasts.count == 1 {
                        let currCast: Cast = searchedCasts[0]
                        print("found original cast: \(currCast.name)")
                        currCast.addToCredits(credit)
                    } else { fatalError("duplicated casts") }
                    print("end injection.")
                }
                //                self.credits!.append(
                //                    Credit(cast: casts, id: UInt32(row["id"]!)!)
                //                )
            }
        } catch {
            fatalError("Error to convert CSV file: \(error)")
        }
        
        if context.hasChanges {
            try! context.save()
            print("saved credits.")
        }
    }
    
    public static func initializeMoviesMetadata(){
        print("initialize MoviesMetadata")
        let path = Bundle.main.path(forResource: "movies_metadata", ofType: ".csv", inDirectory: "DataSet")
        
        let url = URL(filePath: path!)
        
        do {
            let csv = try CSV<Named>(url: url)
            
            for row in csv.rows {
                var genres: [GenreJsonModel]
                
                do {
                    guard var jsonString = row["genres"] else {
                        fatalError("Error to convert row column to string.")
                    }
                    jsonString = jsonString.replacingOccurrences(of: "'", with: "\"")
                    guard let jsonData = jsonString.data(using: .utf8) else {
                        fatalError("Error to convert json string to data.")
                    }
                    let json: [GenreJsonModel] = try self.decoder.decode([GenreJsonModel].self, from: jsonData)
                    genres = json
                } catch {
                    fatalError("Error to convert JSON: \(error)")
                }
                
                guard let raw_id = row["id"],
                      let id = Int32(raw_id) else { print("fatal to convert raw id"); continue }
//                self.metadata![id] = MovieMetadata(
//                    id: UInt32(id),
//                    genres: genres,
//                    overview: row["overview"],
//                    poster_path: row["poster_path"],
//                    title: row["title"]!,
//                    vote_average: Float(row["vote_average"]!) ?? 0.0,
//                    vote_count: UInt32(row["vote_count"]!) ?? 0,
//                    adult: (row["adult"] == "true"),
//                    runtime: row["runtime"]!,
//                    release_date: row["release_date"]!
//                )
                
                let metadata = MovieMetadata(context: context)
                metadata.movie_id = id
                metadata.overview = row["overview"]
                metadata.poster_path = row["poster_path"]
                metadata.title = row["title"]
                metadata.vote_count = Int32(row["vote_count"]!) ?? 0
                metadata.vote_average = Float(row["vote_average"]!) ?? 0.0
                metadata.adult = (row["adult"] == "true")
                metadata.runtime = row["runtime"]
                metadata.release_date = row["release_date"]
                
                // collect genres.
                for genre in genres {
                    let searchedGenre = try! context.fetch(Genre.fetchRequest()).filter { $0.name == genre.name}
                    if searchedGenre.isEmpty {
                        let g = Genre(context: context)
                        g.name = genre.name
                        g.metadata = NSSet(array: [metadata])
                    } else if searchedGenre.count == 1 {
                        let g: Genre = searchedGenre[0]
                        g.addToMetadata(metadata)
                    } else { fatalError("duplicated genres") }
                }
            }
            
        } catch {
            fatalError("Error to convert CSV file: \(error)")
        }
        
        if context.hasChanges {
            try! context.save()
            print("saved movie_metadata.")
        }
    }
}
