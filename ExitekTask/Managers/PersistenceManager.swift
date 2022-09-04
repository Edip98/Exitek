//
//  PersistenceManager.swift
//  ExitekTask
//
//  Created by Эдип on 31.08.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExitekTask")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Loading for store failed: \(error)")
            }
        }
        return container
    }()
    
    func fetchMovie() -> [Movie] {
        let fetchRequest = NSFetchRequest<Movie>(entityName: "Movie")
        
        do {
            let movies = try mainContext.fetch(fetchRequest)
            return movies
        } catch let fetchError {
            print("Failed to fetch movies:", fetchError)
            return []
        }
    }

    
    func createMovie(title: String, year: Int) {
        let movie = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: mainContext) as! Movie
        movie.setValue(title, forKey: "title")
        movie.setValue(year, forKey: "year")
        saveMovie()
    }
    
    func saveMovie() {
        guard mainContext.hasChanges else { return }

        do {
            try mainContext.save()
        } catch let saveError {
            print("Failed to save movie:", saveError)
        }
    }
    
    func deleteMovie(movie: NSManagedObject, title: String) {
        let movies = fetchMovie()
                
        if movies.count > 0 {
            movies.forEach { item in
                if item.title == title {
                    mainContext.delete(item)
                }
            }
        }
        saveMovie()
    }
}
