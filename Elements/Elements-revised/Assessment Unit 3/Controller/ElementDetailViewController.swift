//
//  ElementDetailViewController.swift
//  Assessment Unit 3
//
//  Created by Jaheed Haynes on 12/19/19.
//  Copyright © 2019 Jaheed Haynes. All rights reserved.
//

import UIKit

class ElementDetailViewController: UIViewController {
    
    @IBOutlet weak var elementImageDVC: UIImageView!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var meltingPoint: UILabel!
    @IBOutlet weak var boilingPoint: UILabel!
    @IBOutlet weak var discoveredBy: UILabel!
    
    
    var element: Element?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //----------------------------------------------------------------

    
    private func updateUI(){
        guard let element = element else {
            fatalError("could not access element, verify it's in your segue method")
            }
        symbol.text = element.symbol
        number.text = element.number.description
        weight.text = element.atomicMass?.description
        meltingPoint.text = element.melt?.description
        boilingPoint.text = element.boil?.description
        discoveredBy.text = element.discoveredBy
        
        elementImageDVC.getImage(with: imageString(for: element)) {[weak self] (result) in
           switch result {
            case .failure:
              DispatchQueue.main.async {
                self?.elementImageDVC.image = UIImage(systemName: "mic.fill")
              }
            case .success(let image):
              DispatchQueue.main.async {
                self?.elementImageDVC.image = image
              }
              
            }
        }
    }
    
    func imageString(for element: Element) -> String {
       let urlString = "http://images-of-elements.com/\(element.name.lowercased()).jpg"
       return urlString
     }
     //-----------------------------------------------------------------------------------------------------------------
       // MARK: PUSH ACTION METHODS (FAVORITE)
    
    @IBAction func favoriteElement(_ sender: UIBarButtonItem) {
        
         sender.isEnabled = true
        
        guard let element = element else {
            fatalError("could not favorite podcast")
           
            return
        }
        
        let postedFavorite = Element(name: element.name, atomicMass: element.atomicMass, boil: element.boil,
                                     discoveredBy: element.discoveredBy, melt: element.melt, number: element.number,
                                     symbol: element.symbol, spectralImg: element.spectralImg, favoritedBy: "JAHEED H.")
        
        ElementAPIClient.postFavorite(for: postedFavorite) {[weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Can't add that element")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Facvorite Posted", message: "Your Favorite Element has been favorited") {
                        alert in self?.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    //-----------------------------------------------------------------------------------------------------------------


}
