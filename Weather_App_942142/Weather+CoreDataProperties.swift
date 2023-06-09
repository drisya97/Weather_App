//
//  Weather+CoreDataProperties.swift
//  Weather_App_942142
//
//  Created by Drisya Sudevan on 08/06/23.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var weatherDetails: Data?

}

extension Weather : Identifiable {

}
