//
//  SearchCountry+CoreDataProperties.swift
//  Countries
//
//  Created by user on 12/03/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import CoreData


extension SearchCountry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchCountry> {
        return NSFetchRequest<SearchCountry>(entityName: "SearchCountry")
    }

    @NSManaged public var callingCodes: String?
    @NSManaged public var capital: String?
    @NSManaged public var currencies: String?
    @NSManaged public var flag: String?
    @NSManaged public var languages: String?
    @NSManaged public var name: String?
    @NSManaged public var region: String?
    @NSManaged public var subregion: String?
    @NSManaged public var timezones: String?

}
