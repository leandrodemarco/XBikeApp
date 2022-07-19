//
//  RideSummaryViewPresenter.swift
//  XBike
//
//  Created by Leandro.Demarco on 18/07/2022.
//

import Foundation
import CoreLocation

protocol RideSummaryViewPresenterDelegate: AnyObject {
    func rideSavedWithError(_ error: Error?)
    func discardCurrentRide()
}

class DefaultRideSummaryViewPresenter: RideSummaryViewPresenter {
    let rideDuration: TimeInterval
    let rideDistance: Double
    private let startPoint: CLLocationCoordinate2D?
    private let endPoint: CLLocationCoordinate2D?
    private let rideRepository: RideRepository
    private unowned let delegate: RideSummaryViewPresenterDelegate
    private let timeFormatter: TimeFormatter
    private let reverseGeoCoder: ReverseGeoCoder

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
        startPoint: CLLocationCoordinate2D?,
        endPoint: CLLocationCoordinate2D?,
        rideRepository: RideRepository,
        timeFormatter: TimeFormatter,
        reverseGeoCoder: ReverseGeoCoder
    ) {
        self.delegate = delegate
        self.rideDuration = rideDuration
        self.rideDistance = rideDistance
        self.rideRepository = rideRepository
        self.timeFormatter = timeFormatter
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.reverseGeoCoder = reverseGeoCoder
    }

    func deleteTapped() {
        delegate.discardCurrentRide()
    }

    func storeTapped() {
        let distance = rideDistance
        let duration = rideDuration
        reverseGeoCoder.getStringAddressFrom(location: startPoint) { [weak self] startAddress in
            self?.reverseGeoCoder.getStringAddressFrom(location: self?.endPoint) { endAddress in
                let rideModel = RideModel(distanceInMeters: distance,
                                          durationInSeconds: Int64(duration),
                                          endAddress: startAddress,
                                          startAddress: endAddress)
                let saveError = self?.rideRepository.save(rideModel)
                self?.delegate.rideSavedWithError(saveError)
            }
        }
    }
}
