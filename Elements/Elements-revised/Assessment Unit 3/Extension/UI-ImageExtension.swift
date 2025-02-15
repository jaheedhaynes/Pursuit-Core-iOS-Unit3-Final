//
//  UI-ImageExtension.swift
//  Assessment Unit 3
//
//  Created by Jaheed Haynes on 12/19/19.
//  Copyright © 2019 Jaheed Haynes. All rights reserved.
//

import UIKit

// here we crate an extension on UIImageView to hand off getting a UIImage using
// our URLSession wrapper class (NetworkHelper)

extension UIImageView {
  func getImage(with urlString: String,
                completion: @escaping (Result<UIImage, AppError>) -> ()) {
    
    // The UIActivityIndicatorView is used to indicate to the user that a download is in progress
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.color = .orange
    activityIndicator.startAnimating() // it's hidden until we explicitly start animating
        
    addSubview(activityIndicator) // we add the indicattor as a subview of the image view
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                                 activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
    
    
    guard let url = URL(string: urlString) else {
      completion(.failure(.badURL(urlString)))
      return
    }
    
    let request = URLRequest(url: url)
    
    NetworkHelper.shared.performDataTask(with: request) { [weak activityIndicator] (result) in
      DispatchQueue.main.async {
        activityIndicator?.stopAnimating() // hides when we stop animating the indicator
      }
      switch result {
      case .failure(let appError):
        completion(.failure(.networkClientError(appError)))
      case .success(let data):
        if let image = UIImage(data: data) {
          completion(.success(image))
        }
      }
    }
  }
}
