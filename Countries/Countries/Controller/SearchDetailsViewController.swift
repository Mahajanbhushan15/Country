//
//  SearchDetailsViewController.swift
//  Countries
//
//  Created by user on 12/03/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import WebKit
import Reachability

class SearchDetailsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var saveBtn: UIBarButtonItem!
    var searchDetail : SearchModel?
    
    @IBOutlet weak var flagImage: WKWebView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkConnectivity()
    }
    
    fileprivate func checkConnectivity(){
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        let reachability = notification.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
            // Get all local store counties data.
        }
    }
    
    // Bind data to UI.
    fileprivate func bindData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            NetworkManager.isUnreachable{_ in
                self.saveBtn.isEnabled = false
            }
            
            NetworkManager.isReachable {_ in
                self.saveBtn.isEnabled = true
            }
            // Load SVG image
            if let flagUrl = self.searchDetail?.flag {
                self.flagImage.loadSVGImage(imageUrl: URL(string: flagUrl)!)
            }
        }
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name: \(searchDetail?.name ?? "")"
            break;
        case 1:
            cell.textLabel?.text = "Capital: \(searchDetail?.capital ?? "")"
            break;
        case 2:
            cell.textLabel?.text = "Code: \(searchDetail?.callingCodes?[0] ?? "")"
            break;
        case 3:
            cell.textLabel?.text = "Region: \(searchDetail?.region ?? "")"
            break;
        case 4:
            cell.textLabel?.text = "Sub region: \(searchDetail?.subregion ?? "")"
            break;
        case 5:
            cell.textLabel?.text = "Timezones: \(searchDetail?.timezones?[0] ?? "")"
            break;
        case 6:
            cell.textLabel?.text = "Currencies: \(searchDetail?.currencies?[0].name ?? "")"
            break;
        case 7:
            cell.textLabel?.text = "Name: \(searchDetail?.name ?? "")"
            break;
        case 8:
            cell.textLabel?.text = "Languages: \(searchDetail?.languages?[0].name ?? "")"
            break;
        default: break
        }
        
        return cell
    }
    
    //Mark: IBACtion to save data into local database.
    @IBAction func saveOfflineData(_ sender: Any) {
        // Save data into local storage.
        SearchCountry().saveData(searchModel: searchDetail!)
    }
}
