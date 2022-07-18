//
//  CD_Ride+CoreDataClass.swift
//  XBike
//
//  Created by Leandro.Demarco on 14/07/2022.
//
//

import Foundation
import CoreData

@objc(CD_Ride)
public class CD_Ride: NSManagedObject {
    func populateFrom(_ domainModel: RideModel) {
        distanceInMeters = domainModel.distanceInMeters
        durationInSeconds = domainModel.durationInSeconds
        startAddress = domainModel.startAddress
        endAddress = domainModel.endAddress
    }

    func toDomainModel() -> RideModel? {
        guard let startAddress = startAddress,
              let endAddress = endAddress
        else {
            return nil
        }
        return RideModel(distanceInMeters: distanceInMeters,
                         durationInSeconds: durationInSeconds,
                         endAddress: endAddress,
                         startAddress: startAddress)
    }
}
