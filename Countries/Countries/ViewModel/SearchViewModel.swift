//
//  SearchViewModel.swift
//  Countries
//
//  Created by user on 12/03/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

struct SearchViewModel {
    
    func getSerachResult(requestUrl: String, completionHandler: @escaping ([SearchModel]?, String?) -> Void){
        
        // Create request URL
        let searchURL = URL.baseURLString + URL.searchEndPoint + requestUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: searchURL)
        
        if let requestUrl = url {
            
            ConnectionManager().getSearchResults(searchURL: requestUrl) { (response, errorMessage) in
                
                guard let dataResponse = response, errorMessage == nil else {
                    return completionHandler(nil,errorMessage)
                }
                do{
                    //Here dataResponse received from a network request.
                    
                    // Parse data
                    let jsonData = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! [[String : AnyObject]]
                    
                    let searchList = SearchModel.parseCountryData(responseData: jsonData)
                    
                    completionHandler(searchList,nil)
                    
                } catch let parsingError {
                    completionHandler(nil,parsingError.localizedDescription)
                }
            }
        }
    }
    
    // Get offline data when network is unreachable.
    func getOfflineDataForAllCountries() -> [SearchModel] {
       return SearchCountry().fetchAllCountiesData()
    }
    
    // Get offline data when network is unreachable and search text contains input string
    func getOfflineData(searchString: String) -> [SearchModel] {
        return SearchCountry().fetchData(searchString: searchString)
    }
}
