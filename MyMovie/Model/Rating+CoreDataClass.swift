//
//  Rating+CoreDataClass.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/06/14.
//
//

import Foundation
import CoreData

@objc(Rating)
public class Rating: NSManagedObject {
    public func findByMovie(movie: MovieMetadata) -> [Rating] {
        let req = NSFetchRequest<Rating>(entityName: "Rating")
        let pred = NSPredicate(format: "movie == %@", movie)
        req.predicate = pred
        
        // we will perform the request on the context associated with the School NSManagedObject
        guard let context = movie.managedObjectContext else {
            print("provided School managed object is not associated with a managed object context")
            return []
        }
        
        do {
            return try context.fetch(req)
        } catch {
            return []
        }
    }
}
