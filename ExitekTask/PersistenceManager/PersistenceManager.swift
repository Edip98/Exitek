//
//  PersistenceManager.swift
//  ExitekTask
//
//  Created by Эдип on 07.09.2022.
//

import Foundation

enum Keys {
    static let favorites = "favorites"
}

class PersistenceManager {
    
    static let shared = PersistenceManager()
    private let defaults = UserDefaults.standard
    
    func retriveFavorites() -> [Movie] {
        guard let data = defaults.object(forKey: Keys.favorites) as? Data else { return [] }
        
        var movie: [Movie] = []
        
        do {
            let decoder = JSONDecoder()
            movie = try decoder.decode([Movie].self, from: data)
        } catch {
            print("Unable to decode Movie (\(error))")
        }
        return movie
    }
    
    func save(favorites: [Movie]) {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
        } catch {
            print("Unable to encode Movie (\(error))")
        }
    }
}



