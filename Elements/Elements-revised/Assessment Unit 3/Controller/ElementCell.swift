//
//  ElementTableViewCell.swift
//  Assessment Unit 3
//
//  Created by Jaheed Haynes on 12/19/19.
//  Copyright © 2019 Jaheed Haynes. All rights reserved.
//

import UIKit

class ElementCell: UITableViewCell {

    @IBOutlet weak var elementImage: UIImageView!
    @IBOutlet weak var elementName: UILabel!
    @IBOutlet weak var atomicWeight: UILabel!
    
    private var urlString = ""
    
    //----------------------------------------------------------------

    
    func configureCell(for element: Element) {
        elementName.text = element.name
        atomicWeight.text = element.atomicMass?.description
        
        guard let imageURL = element.spectralImg else {
            elementImage.image = UIImage(systemName: "mic.fill")
            return
        }
        urlString = imageURL
        
        elementImage.getImage(with: imageURL) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.elementImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    if self?.urlString == imageURL {
                        self?.elementImage.image = image
                    }
                }
            }
        }
    }
    
    func imageString(for element: Element) -> String {
      var urlString = ""
      if element.number < 10 {
        urlString = "http://www.theodoregray.com/periodictable/Tiles/00\(element.number)/s7.JPG"
      } else if element.number < 100 {
        urlString = "http://www.theodoregray.com/periodictable/Tiles/0\(element.number)/s7.JPG"
      } else {
        urlString = "http://www.theodoregray.com/periodictable/Tiles/\(element.number)/s7.JPG"
      }
      return urlString
    }
    //----------------------------------------------------------------

    override func prepareForReuse() {
      super.prepareForReuse()
      elementImage.image = UIImage(systemName: "mic.fill")
    }
    
}
