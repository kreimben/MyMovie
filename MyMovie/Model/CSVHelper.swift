//
//  CSVHelper.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/05/26.
//

import SwiftCSV
import Foundation

class CSVHelper {
    private static let decoder = JSONDecoder()
    private static var metadata: Dictionary<Int, MovieMetadata>? = nil
    private static var credits: [Credit]? = nil
    private static var ratings: [Rating]? = nil
    
    
    public static func getRatings() -> [Rating] {
        if self.ratings == nil {
            let path = Bundle.main.path(forResource: "ratings", ofType: ".csv", inDirectory: "DataSet")
            
            let url = URL(filePath: path!)
            
            do {
                let csv = try CSV<Named>(url: url)
                
                self.ratings = []
                
                csv.rows.enumerated().forEach { index, row in
                    print("ratings: \(index) / \(csv.rows.count)")
                    self.ratings!.append(
                        Rating(
                            user_id: UInt32(row["userId"] ?? "0")!,
                            movie_id: UInt32(row["movieId"] ?? "0")!,
                            rating: Float(row["rating"] ?? "0.0")!,
                            timestamp: UInt64(row["timestamp"] ?? "0")!
                        )
                    )
                }
            } catch {
                fatalError("Error to convert CSV file: \(error)")
            }
        }
        return self.ratings!
    }
    
    
    public static func getCredits() -> [Credit] {
        if self.credits == nil {
            let path = Bundle.main.path(forResource: "credits", ofType: ".csv", inDirectory: "DataSet")
            
            let url = URL(filePath: path!)
            
            do {
                let csv = try CSV<Named>(url: url)
                
                self.credits = []
                
                csv.rows.enumerated().forEach { index, row in
                    var casts: [Cast] = []
                    
                    do {
                        guard var jsonString = row["cast"] else {
                            fatalError("Error to convert row column to string.")
                        }
                        jsonString = jsonString.replacingOccurrences(of: "'", with: "\"")
                        jsonString = jsonString.replacingOccurrences(of: "None", with: "null")
                        guard let jsonData = jsonString.data(using: .utf8) else {
                            fatalError("Error to convert json string to data.")
                        }
                        print("before converting cast json")
                        let json: [Cast] = try self.decoder.decode([Cast].self, from: jsonData)
                        print("after converting cast json")
                        casts = json
                    } catch {
                        //                        print("Error to convert JSON: \(error)")
                    }
                    
                    print("credits: \(index) / \(csv.rows.count)")
                    self.credits!.append(
                        Credit(cast: casts, id: UInt32(row["id"]!)!)
                    )
                }
            } catch {
                fatalError("Error to convert CSV file: \(error)")
            }
        }
        
        return self.credits!
    }
    
    public static func getMoviesMetadata() -> Dictionary<Int, MovieMetadata> {
        if self.metadata == nil {
            let path = Bundle.main.path(forResource: "movies_metadata", ofType: ".csv", inDirectory: "DataSet")
            
            let url = URL(filePath: path!)
            
            do {
                let csv = try CSV<Named>(url: url)
                
                self.metadata = [:]
                
                csv.rows.enumerated().forEach { index, row in
                    var genres: [Genre]
                    
                    do {
                        guard var jsonString = row["genres"] else {
                            fatalError("Error to convert row column to string.")
                        }
                        jsonString = jsonString.replacingOccurrences(of: "'", with: "\"")
                        guard let jsonData = jsonString.data(using: .utf8) else {
                            fatalError("Error to convert json string to data.")
                        }
                        print("before converting genre json")
                        let json: [Genre] = try self.decoder.decode([Genre].self, from: jsonData)
                        print("after converting genre json")
                        genres = json
                    } catch {
                        fatalError("Error to convert JSON: \(error)")
                    }
                    
                    // collect genres.
                    for genre in genres {
                        AllGenres.insert(genre)
                    }
                    
                    guard let row_id = row["id"],
                          let id = Int(row_id) else { fatalError("fatal to convert row id") }
                    print("metadata: \(index) / \(csv.rows.count)")
                    self.metadata![id] = MovieMetadata(id: UInt32(id),
                                                       genres: genres,
                                                       overview: row["overview"],
                                                       poster_path: row["poster_path"],
                                                       title: row["title"]!,
                                                       vote_average: Float(row["vote_average"]!) ?? 0.0,
                                                       vote_count: UInt32(row["vote_count"]!) ?? 0,
                                                       adult: (row["adult"] == "true"),
                                                       runtime: row["runtime"]!,
                                                       release_date: row["release_date"]!
                    )
                }
                
            } catch {
                fatalError("Error to convert CSV file: \(error)")
            }
        }
        
        return self.metadata!
    }
}
