//
//  SearchController.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit
import Alamofire
import Hero

class SearchController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var results: [UserModel] = []
    
    var currentRequest: DataRequest?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        isHeroEnabled = true
        Helper.createGradientOnView(view: view, colors: Test.Result.additional.colors())
        view.heroID = "searchBack"
        
        setupSearch()
        performSearch(with: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    func setupSearch() {

        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        searchController.searchBar.barStyle = .blackTranslucent
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.clipsToBounds = true
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUser" {
            let user = sender as! UserModel
            (segue.destination as! AddConnectionController).user = user
        }
    }
    
}

extension SearchController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let q = searchController.searchBar.text!
        performSearch(with: q)
    }
    
    func performSearch(with q: String) {
        currentRequest?.cancel()
        
        currentRequest = API.search(with: q) { [unowned self] json in
            self.results = parseUsers(json: json)
            self.tableView.reloadData()
        }
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
}

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResults(for: searchController)
    }
}

extension SearchController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
        
        cell.configure(user: results[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        cell.personName.heroID = "searchName"
        cell.personImage.heroID = "searchImage"
        
        performSegue(withIdentifier: "toUser", sender: results[indexPath.row])
    }
    
}
