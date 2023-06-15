//
//  AppDelegate.swift
//  MyMovie
//
//  Created by Aksidion Kreimben on 2023/05/26.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Check if database is empty.
        // if not empty, pass injection
        // if empty, initialize DB.
        
        let movies = try! self.persistentContainer.viewContext.fetch(MovieMetadata.fetchRequest())
        if movies.isEmpty {
            CSVHelper.initializeMoviesMetadata()
        }
        
        let credits = try! self.persistentContainer.viewContext.fetch(Credit.fetchRequest())
        if credits.isEmpty {
            CSVHelper.initializeCredits()
        }
        
//        let ratings = try! self.persistentContainer.viewContext.fetch(Rating.fetchRequest())
//        if ratings.isEmpty {
        CSVHelper.initializeRatings() // load `ratings.csv` file to memory.
//        }
        
        
        
            /*
             Only uncomment below when you want to clear database.
             */
            
//            #if DEBUG
//            let entities = ["Cast", "Credit", "Genre", "MovieMetadata", "Rating"]
//            for entityName in entities {
//                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//                let context = self.persistentContainer.viewContext
//                let coordinator = self.persistentContainer.viewContext.persistentStoreCoordinator!
//
//                do {
//                    try coordinator.execute(deleteRequest, with: context)
//                    print("\(entityName) entity cleared.")
//                } catch let error as NSError {
//                    print("There was an error: \(error)")
//                }
//            }
//
//            try! self.persistentContainer.viewContext.save()
//            print("\(entities) Database Cleared!")
//            #endif
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - CoreData
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entity")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as? NSError {
                fatalError("Error to loading persistent stores.")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

