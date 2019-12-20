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
    
    
    var currentElement: Element?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //----------------------------------------------------------------

    
    private func updateUI(){
        guard let element = currentElement else {
            fatalError("could not access element, verify it's in your segue method")
            }
        symbol.text = element.symbol
        number.text = element.number.description
        weight.text = element.atomicMass?.description
        meltingPoint.text = element.melt?.description
        boilingPoint.text = element.boil?.description
        discoveredBy.text = element.discoveredBy
        navigationItem.title = element.name
        
        elementImageDVC.getImage(with: imageString(for: element)) {[weak self] (result) in
           switch result {
            case .failure:
              DispatchQueue.main.async {
                self?.elementImageDVC.image = UIImage(systemName: "person.fill")
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
        
        print("button pressed")
        
        guard let element = currentElement else {
          showAlert(title: "Failed", message: "Unable to favorite this element, please try again.")
          sender.isEnabled = true
          return
            
        }
        
        let favorite = Element(name: element.name, atomicMass: element.atomicMass, boil: element.boil, discoveredBy: element.discoveredBy, melt: element.melt, number: element.number, symbol: element.symbol, favoritedBy: "JAHEED H.")
        
        ElementAPIClient.postFavorite(postFavorite: favorite) { [weak self] (result) in
            switch result {
            case.failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Can not Favorite Element, please try again", message: "\(appError)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Success", message: "Element has been added to favorites") {
                        alert in self?.dismiss(animated: true)
                    }
                }
            }
        }
        
    }
    
    //-----------------------------------------------------------------------------------------------------------------


}
