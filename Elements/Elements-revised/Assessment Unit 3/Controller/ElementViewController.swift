//
//  ViewController.swift
//  Assessment Unit 3
//
//  Created by Jaheed Haynes on 12/19/19.
//  Copyright © 2019 Jaheed Haynes. All rights reserved.
//

import UIKit

class ElementViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var elements = [Element]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //----------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
//        searchBar.autocapitalizationType = .none
        searchElements(with: "")
        getElements()   
        
    }
    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: METHOD SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let elementDetailVC = segue.destination as? ElementDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("could not downcast to ElementDetailViewController")
        }
        let element = elements[indexPath.row]
        elementDetailVC.element = element
    }
  
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: METHOD to get the elements
    
     private func getElements() {
           ElementAPIClient.getElement { [weak self](result) in
               switch result {
               case .success(let elements):
                   self?.elements = elements
               case .failure(let appError):
                   print("appError \(appError)")
               }
           }
       }
    
    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: METHOD TO SEARCH ELEMENTS
    
    private func searchElements(with name: String) {
        ElementAPIClient.getElement(completion: {[weak self] (result) in
            switch result {
            case.failure(let appError):
                print("\(appError)")
            case .success(let element):
                self?.elements = element
            }
        })
    }
}



//-----------------------------------------------------------------------------------------------------------------
// MARK: EXTENSIONS

extension ElementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "elementCell", for: indexPath) as? ElementCell else {
            fatalError("could not downcast to Podcast Cell")
        }
        let element = elements[indexPath.row]
        cell.configureCell(for: element)
        
        return cell
    }
    
    
}

//----------------------------------------------------------------

extension ElementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

//----------------------------------------------------------------

extension ElementViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchElements(with: searchText)
    }
}
