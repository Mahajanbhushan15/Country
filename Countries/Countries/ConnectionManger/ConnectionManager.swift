//
//  ConnectionManager.swift
//  Countries
//
//  Created by user on 12/03/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

public class ConnectionManager: NSObject {
    
    typealias JSONDictionary = [String: AnyObject]
    typealias QueryResult = (Data?, String?) -> ()
    
    // NSURLSession configuration.
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    
    // Get countries data from server.
    
    func getSearchResults(searchURL: URL, completion: @escaping QueryResult) {
        
        // Cancel already running task.
        dataTask?.cancel()
        
        // Create URL request.
        dataTask = defaultSession.dataTask(with: searchURL) { data, response, error in
                defer { self.dataTask = nil }
                
                // Check success or error
                if let error = error {
                    
                    self.errorMessage += "Error: " + error.localizedDescription + "\n"
                    
                    // Handle Failure.
                    completion(nil, self.errorMessage)
                    
                } else if let data = data,
                    
                    let response = response as? HTTPURLResponse,
                    
                    response.statusCode == 200 {
                    
                    // Handle sucess.
                    completion(data, nil)
                }
            }
            dataTask?.resume()
    }
}
