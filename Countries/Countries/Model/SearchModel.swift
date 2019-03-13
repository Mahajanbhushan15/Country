//
//  SearchModel.swift
//  Countries
//
//  Created by user on 12/03/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

public typealias JSONDictionary = [String: AnyObject]

public class SearchModel: NSObject {
    
    var flag : String?
    var name : String?
    var capital : String?
    var callingCodes : [String]?
    var region : String?
    var subregion : String?
    var timezones : [String]?
    var currencies : [Currency]?
    var languages : [Language]?
    
    override init(){}
    
     init(dictionary:JSONDictionary) {
        flag = dictionary["flag"] as? String
        name = dictionary["name"] as? String
        capital = dictionary["capital"] as? String
        callingCodes = dictionary["callingCodes"] as? [String]
        region = dictionary["region"] as? String
        subregion = dictionary["subregion"] as? String
        timezones = dictionary["timezones"] as? [String]
        languages = Language.parseLanguageData(responseData: dictionary["languages"] as! [JSONDictionary])
        currencies =  Currency.parseCurrencyData(responseData: dictionary["currencies"] as! [JSONDictionary])
    }
    
    static func initWithOfflineData(dictionary:JSONDictionary) -> SearchModel {
        let searchModel = SearchModel()
        searchModel.flag = dictionary["flag"] as? String
        searchModel.name = dictionary["name"] as? String
        searchModel.capital = dictionary["capital"] as? String
        searchModel.callingCodes = dictionary["callingCodes"] as? [String]
        searchModel.region = dictionary["region"] as? String
        searchModel.subregion = dictionary["subregion"] as? String
        searchModel.timezones = dictionary["timezones"] as? [String]
//        let language = Language()
//        language.name = dictionary["languages"] as? String
//        searchModel.languages?.append(language)
        return searchModel
        //languageArray.append(dictionary["languages"] as! [JSONDictionary])
        //searchModel.currencies =  Currency.parseCurrencyData(responseData: dictionary["currencies"] as! [JSONDictionary])
    }
    
    class func parseOfflineData(responseData:[JSONDictionary])->[SearchModel]
    {
        var modelArray = [SearchModel]()
        for dictionary in responseData
        {
            let model = SearchModel.initWithOfflineData(dictionary: dictionary)
            modelArray.append(model)
        }
        return modelArray
    }
    
    class func parseCountryData(responseData:[JSONDictionary])->[SearchModel]
    {
        var modelArray = [SearchModel]()
        for dictionary in responseData
        {
            let model = SearchModel.init(dictionary: dictionary)
            modelArray.append(model)
        }
        return modelArray
    }
}

public class Currency: NSObject {
    var code: String?
    var name: String?
    var symbol: String?
    
    init(dictionary:JSONDictionary) {
        self.code = dictionary["code"] as? String
        self.name = dictionary["name"] as? String
        self.symbol = dictionary["symbol"] as? String
    }

    class func parseCurrencyData(responseData:[JSONDictionary])->[Currency]
    {
        var currenyArray = [Currency]()
        for dictionary in responseData
        {
            let model = Currency.init(dictionary: dictionary)
            currenyArray.append(model)
        }
        return currenyArray
    }
}

public class Language: NSObject {
    var nativeName: String?
    var iso639_2: String?
    var name: String?
    var iso639_1: String?
    
    init(dictionary:JSONDictionary) {
        self.nativeName = dictionary["nativeName"] as? String
        self.iso639_2 = dictionary["iso639_2"] as? String
        self.name = dictionary["name"] as? String
        self.iso639_1 = dictionary["iso639_1"] as? String
    }
    
    class func parseLanguageData(responseData:[JSONDictionary])->[Language]
    {
        var languageArray = [Language]()
        for dictionary in responseData
        {
            let model = Language.init(dictionary: dictionary)
            languageArray.append(model)
        }
        return languageArray
    }
}
