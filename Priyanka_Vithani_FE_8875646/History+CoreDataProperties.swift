//
//  History+CoreDataProperties.swift
//  Priyanka_Vithani_FE_8875646
//
//  Created by Priyanka Vithani on 06/12/23.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var typeOfInteraction: String?
    @NSManaged public var cityName: String?
    @NSManaged public var transactionTo: String?
    @NSManaged public var newsTitle: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var newsSource: String?
    @NSManaged public var newsAuthor: String?
    @NSManaged public var weatherDate: String?
    @NSManaged public var weatherTime: String?
    @NSManaged public var temperature: String?
    @NSManaged public var humidity: String?
    @NSManaged public var wind: String?
    @NSManaged public var startPoint: String?
    @NSManaged public var endPoint: String?
    @NSManaged public var travelMethod: String?
    @NSManaged public var totalDistance: String?

}

extension History : Identifiable {

}
