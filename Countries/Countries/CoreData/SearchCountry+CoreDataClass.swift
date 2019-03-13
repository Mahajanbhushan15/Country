//
//  SearchCountry+CoreDataClass.swift
//  Countries
//
//  Created by user on 12/03/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(SearchCountry)
public class SearchCountry: NSManagedObject {
    
    // Save data into local storage.
    func saveData(searchModel: SearchModel){
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let countryToSave = NSEntityDescription.insertNewObject(forEntityName: "SearchCountry", into: managedContext) as! SearchCountry
        
        countryToSave.setValue(searchModel.name, forKeyPath: "name")
        countryToSave.setValue(searchModel.flag, forKey: "flag")
        countryToSave.setValue(String(describing: searchModel.capital), forKey: "capital")
        countryToSave.setValue(String(describing: searchModel.callingCodes?[0]), forKey: "callingCodes")
        countryToSave.setValue(String(describing: searchModel.region), forKey: "region")
        countryToSave.setValue(String(describing: searchModel.subregion), forKey: "subregion")
        countryToSave.setValue(String(describing: searchModel.timezones?[0]), forKey: "timezones")
        countryToSave.setValue(String(describing: searchModel.languages?[0].name), forKey: "languages")
        countryToSave.setValue(String(describing: searchModel.currencies?[0].name), forKey: "currencies")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Fetch local storage data for search string
    func fetchData(searchString: String) -> [SearchModel]{
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let countryFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchCountry")
        
        countryFetch.predicate = NSPredicate(format: "name contains[c] %@", searchString)
        
        countryFetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        
        let countries = try? managedContext.fetch(countryFetch) as? [NSManagedObject]
        
        return convertToJSONArray(moArray: countries as! [NSManagedObject])
    }
    
    // Fetch all local storage data.
    func fetchAllCountiesData() -> [SearchModel]{
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let countryFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchCountry")
        
        countryFetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        
        let countries = try? managedContext.fetch(countryFetch) as? [NSManagedObject]
        
        return convertToJSONArray(moArray: countries as! [NSManagedObject])
    }
    
   fileprivate func convertToJSONArray(moArray: [NSManagedObject]) -> [SearchModel] {
    
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return SearchModel.parseOfflineData(responseData: jsonArray as [[String: Any]] as [JSONDictionary])
    }
}
