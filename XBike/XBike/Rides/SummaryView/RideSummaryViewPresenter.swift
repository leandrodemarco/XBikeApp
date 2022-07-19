//
//  RideSummaryViewPresenter.swift
//  XBike
//
//  Created by Leandro.Demarco on 18/07/2022.
//

import Foundation

protocol RideSummaryViewPresenterDelegate: AnyObject {
    func rideSavedWithError(_ error: Error?)
    func discardCurrentRide()
}

class DefaultRideSummaryViewPresenter: RideSummaryViewPresenter {
    let rideDuration: TimeInterval
    let rideDistance: Double
    private let rideRepository: RideRepository
    private unowned let delegate: RideSummaryViewPresenterDelegate
    private let timeFormatter: TimeFormatter

    var durationString: String {
        timeFormatter.formatTime(rideDuration)
    }

    var distanceString: String {
        let distanceInKm = rideDistance / 1000
        return String(format: "%.1f km", distanceInKm)
    }

    init(
        delegate: RideSummaryViewPresenterDelegate,
        rideDuration: TimeInterval,
        rideDistance: Double,
        rideRepository: RideRepository,
        timeFormatter: TimeFormatter
    ) {
        self.delegate = delegate
        self.rideDuration = rideDuration
        self.rideDistance = rideDistance
        self.rideRepository = rideRepository
        self.timeFormatter = timeFormatter
    }

    func deleteTapped() {
        delegate.discardCurrentRide()
    }

    func storeTapped() {
        let rideModel = RideModel(distanceInMeters: rideDistance,
                                  durationInSeconds: Int64(rideDuration),
                                  endAddress: "end point",
                                  startAddress: "start point")
        let saveError = rideRepository.save(rideModel)
        delegate.rideSavedWithError(saveError)
    }
}
