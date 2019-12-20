//
//  ElementAPI.swift
//  Assessment Unit 3
//
//  Created by Jaheed Haynes on 12/19/19.
//  Copyright © 2019 Jaheed Haynes. All rights reserved.
//

import Foundation

struct ElementAPIClient {
    //-------------------------------------------------------------------------------------------------------------
    //MARK: *** GET ELEMENT ***
    
    static func getElement(completion: @escaping (Result<[Element], AppError>) -> ()) {
        
        let elementEndPointURLString = "https://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/elements"
        
        guard let url = URL(string: elementEndPointURLString)
            else {
                completion(.failure(.badURL(elementEndPointURLString)))
                return
        }
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                  let elements = try JSONDecoder().decode([Element].self, from: data)
                    
                    completion(.success(elements))
                    
                }catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: *** GET FAVORITE ***
    
    static func getFavorite(completion: @escaping (Result<[Element], AppError>) -> ()) {
        
        let favoriteURLString = "http://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/favorites"
        
        guard let url = URL(string: favoriteURLString) else {
            completion(.failure(.badURL(favoriteURLString)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
                
            case .success(let data):
                do {
                    let favorites = try JSONDecoder().decode([Element].self, from: data)
                    let myFavorites = favorites.filter {$0.favoritedBy == "Jaheed H."}
                    completion(.success(myFavorites))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
    }
    
   //-------------------------------------------------------------------------------------------------------------
    //MARK: *** POST FAVORITE ***
    
    static func postFavorite(postFavorite: Element, completion: @escaping(Result<Bool,AppError>) -> ()) {
        
        let postedFavoriteEndpointURLString = "http://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/favorites"
        
        guard let url = URL(string: postedFavoriteEndpointURLString) else {
            completion(.failure(.badURL(postedFavoriteEndpointURLString)))
            return
        }
        do {
            let data = try JSONEncoder().encode(postFavorite)
            
            var request = URLRequest(url: url)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type").self
            
            request.httpBody = data
            
            request.httpMethod = "POST"
            
            NetworkHelper.shared.performDataTask(with: request) { (result) in
              switch result {
              case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
              case .success:
                completion(.success(true))
              }
            }
            
        } catch {
            completion(.failure(.networkClientError(error)))
        }
    }
    
}
