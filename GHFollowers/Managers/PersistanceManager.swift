//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 09/12/2020.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersistanceManager { // enum instead of struct because you cant initialise an empty enum
    
    static private let defaults = UserDefaults.standard // creating our defaults
    
    enum Keys {
        static let favourites = "favourites"
    }
    
    
    static func updateWith(favourite: Follower, actionType: PersistanceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavourites { result in
            switch result {
            case .success(var favourites):
                
                switch actionType {
                case .add:
                    if favourites.contains(favourite) {
                        completed(.alreadyInFavourites)
                        return
                    }
                    favourites.append(favourite)
                    
                case .remove:
                    favourites.removeAll { $0.login == favourite.login }
                }
                
                completed(save(favourites: favourites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func retrieveFavourites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        
        guard let favouritesData = defaults.object(forKey: Keys.favourites ) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Follower].self, from: favouritesData)
            completed(.success(favourites))
        } catch {
            completed(.failure(.unableToFavourite))
        }
    }
    
    
    static func save(favourites: [Follower]) -> GFError? { // returning an error, but its an optional because if we succeed it wont be needed
        
        do {
            let encoder = JSONEncoder()
            let encodedFavourites = try encoder.encode(favourites)
            defaults.setValue(encodedFavourites, forKey: Keys.favourites)
            return nil
        } catch {
            return .unableToFavourite
        }
    }
}
