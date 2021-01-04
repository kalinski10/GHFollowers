//
//  File.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 26/11/2020.
//

import UIKit

class NetworkManager {
    
    static let shared   = NetworkManager() // this is how we acces the network manager
    
    private let baseURL = "https://api.github.com/users/" // URL prefix for the network call
    
    let cache           = NSCache<NSString, UIImage>() // creating the cache here only creates one instance of it
    
    
    private init() {} // this is how we declare it as a singleton

    
    func getFollowers(username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        
        let endPoint = baseURL + "\(username)/followers?per_page=100&page=\(page)" // creating the url for actual call

        guard let url = URL(string: endPoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { //secondary check if the status code is 200 meaning ok // status codes are like the 404 error
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder                 = JSONDecoder() // decoder is taking the json from the server and decoding into our objects // encoder does the opposite
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers               = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }

        task.resume() // this is what actually enables the network call // important to not forget it
    }

    
    func getUserInfo(username: String, completed: @escaping (Result<User, GFError>) -> Void) {
        let endPoint = baseURL + "\(username)"
        
        guard let url = URL(string: endPoint) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder                     = JSONDecoder()
                decoder.keyDecodingStrategy     = .convertFromSnakeCase
                decoder.dateDecodingStrategy    = .iso8601 // converts string to date so the String extension is unnesessary
                let user                        = try decoder.decode(User.self, from: data)
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self      = self,  // single guard statement, if any of these go wrong pass completed nil instead of doing check on every single one
                error           == nil,
                let response    = response as? HTTPURLResponse, response.statusCode == 200,
                let data        = data,
                let image       = UIImage(data: data)
            else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}
