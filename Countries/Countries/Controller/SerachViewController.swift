//
//  SerachControllerViewController.swift
//  Countries
//
//  Created by user on 12/03/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
//import Reachability
import WebKit

class SerachViewController: UITableViewController, UISearchResultsUpdating {

    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    var searchResults = [SearchModel]()
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Search bar.
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //checkConnectivity()
    }
    
//    fileprivate func checkConnectivity(){
//        let reachability = Reachability()!
//
//        reachability.whenReachable = { reachability in
//            if reachability.connection == .wifi {
//                print("Reachable via WiFi")
//            } else {
//                print("Reachable via Cellular")
//            }
//        }
//
//        reachability.whenUnreachable = { _ in
//            print("Not reachable")
//            self.getOfflineOfAllCountries()
//        }
//
//        do {
//            try reachability.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
//    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        let searchModel = self.searchResults[indexPath.row]
        
        if let webView = self.view.viewWithTag(1) as? WKWebView {
            if let flagUrl = searchModel.flag {
                webView.loadSVGImage(imageUrl: URL(string: flagUrl)!)
            }
        }
        
        if let nameLabl = self.view.viewWithTag(2) as? UILabel {
            nameLabl.text = searchModel.name!
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRecord : SearchModel
        if self.searchResults.count > 1{
             selectedRecord = self.searchResults[indexPath.row + 1]
        }else{
             selectedRecord = self.searchResults[indexPath.row]
        }
        
        performSegue(withIdentifier: "navToSearchDetail", sender: selectedRecord)
    }
    
    // MARK: - Search bar
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            fetchResult(searchText : searchText)
        }else{
            self.searchResults = []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // Fetch all local storage data.
    fileprivate func getOfflineOfAllCountries(){
        self.searchResults = SearchViewModel().getOfflineDataForAllCountries()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
    }
    
    // Fecth data base on search input.
    fileprivate func fetchResult(searchText : String){
        
        // Fetch data from API if network is eachable.
        NetworkManager.isReachable { _ in
            SearchViewModel().getSerachResult(requestUrl: searchText) { (response,error)  in
                guard error == nil else{
                    // Alert
                    let alert = UIAlertController(title: "Search fail", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                guard let result = response else{
                    return
                }
                // Bind data to UI.
                self.searchResults = result
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        // Fetch local storage data for search string.
        NetworkManager.isUnreachable { _ in
            // Fetch data from local database.
            self.searchResults = []
            self.searchResults = SearchViewModel().getOfflineData(searchString: searchText)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navToSearchDetail" {
            let selectedData = sender as? SearchModel
            let vc : SearchDetailsViewController = segue.destination as! SearchDetailsViewController
            vc.searchDetail = selectedData
        }
    }
}

