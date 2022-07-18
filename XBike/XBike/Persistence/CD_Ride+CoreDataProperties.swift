//
//  CD_Ride+CoreDataProperties.swift
//  XBike
//
//  Created by Leandro.Demarco on 14/07/2022.
//
//

import Foundation
import CoreData


extension CD_Ride {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_Ride> {
        return NSFetchRequest<CD_Ride>(entityName: "CD_Ride")
    }

    @NSManaged public var durationInSeconds: Int64
    @NSManaged public var distanceInMeters: Double
    @NSManaged public var startAddress: String?
    @NSManaged public var endAddress: String?

}

extension CD_Ride : Identifiable {

}
