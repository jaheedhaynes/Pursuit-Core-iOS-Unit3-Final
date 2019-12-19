//
//  FavoriteViewController.swift
//  Assessment Unit 3
//
//  Created by Jaheed Haynes on 12/19/19.
//  Copyright © 2019 Jaheed Haynes. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    private var refreshControl: UIRefreshControl!
    
    //----------------------------------------------------------------

    
    private var elements = [Element]() {
        
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        configureRefreshControl()
        fetchFavorites()
        
        
    }
    
    //----------------------------------------------------------------

    
    private func configureRefreshControl() {
      refreshControl = UIRefreshControl()
      tableView.refreshControl = refreshControl
      refreshControl.addTarget(self, action: #selector(fetchFavorites), for: .valueChanged)
    }
    
    //----------------------------------------------------------------

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
            
           let elementDetailVC = segue.destination as? ElementDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("could not downcast to PodcastDetailController")
        }
        let element = elements[indexPath.row]
        elementDetailVC.element = element
    }
    
    //----------------------------------------------------------------

    
    
    @objc func fetchFavorites() {
      ElementAPIClient.getFavorite { [weak self] (result) in
        switch result {
        case .failure(let appError):
          print("\(appError)")
          DispatchQueue.main.async {
            self?.refreshControl.endRefreshing()
          }
        case .success(let element):
          DispatchQueue.main.async {
            self?.elements = element
            self?.refreshControl.endRefreshing()
          }
        }
      }
    }
}
//----------------------------------------------------------------


extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "elementCell", for: indexPath) as? ElementCell else {
            fatalError("could not downcast a PodcastCell")
        }
        let element = elements[indexPath.row]
        cell.configureCell(for: element)
        return cell
    }
    
    
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
