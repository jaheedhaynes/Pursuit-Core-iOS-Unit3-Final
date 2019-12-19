//
//  NetworkHelper.swift
//  Assessment Unit 3
//
//  Created by Jaheed Haynes on 12/19/19.
//  Copyright © 2019 Jaheed Haynes. All rights reserved.
//

import Foundation

enum AppError: Error {
case badURL(String) // associated value
case noResponse
case networkClientError(Error) // no internet connection
case noData
case decodingError(Error)
case encodingError(Error)
case badStatusCode(Int) // 404, 500
case badMimeType(String) // image/jpg
}


class NetworkHelper {
  
  static let shared = NetworkHelper()
  
  private var session: URLSession
  

  private init() {
    session = URLSession(configuration: .default)
  }
  
  func performDataTask(with request: URLRequest,
                       completion: @escaping (Result<Data, AppError>) -> ()) {
    
    let dataTask = session.dataTask(with: request) { (data, response, error) in
      
      
      if let error = error {
        completion(.failure(.networkClientError(error)))
        return
      }
      
      guard let urlResponse = response as? HTTPURLResponse else {
        completion(.failure(.noResponse))
        return
      }
      
      guard let data = data else {
        completion(.failure(.noData))
        return
      }
     
      switch urlResponse.statusCode {
      case 200...299: break
      default:
        completion(.failure(.badStatusCode(urlResponse.statusCode)))
        return
      }
      
      completion(.success(data))
    }
    dataTask.resume()
  }
}
