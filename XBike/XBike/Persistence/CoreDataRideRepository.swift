//
//  CoreDataRideRepository.swift
//  XBike
//
//  Created by Leandro.Demarco on 14/07/2022.
//

import Foundation

class CoreDataRideRepository: RideRepository {
    private let stack = CoreDataStack(modelName: "XBike")

    static let singleton: CoreDataRideRepository = {
        let instance = CoreDataRideRepository()
        return instance
    }()

    func save(_ ride: RideModel) -> Error? {
        let coreDataRide = stack.createNewEntity(ofType: CD_Ride.self)
        coreDataRide.populateFrom(ride)
        do {
            try stack.saveContext()
            return nil
        } catch let error {
            return error
        }
    }

    func listAll() -> [RideModel] {
        let fetchRequest = CD_Ride.fetchRequest()
        if let storedRides = try? stack.performFetchRequest(fetchRequest) {
            return storedRides.compactMap { $0.toDomainModel() }
        }
        return []
    }
}
