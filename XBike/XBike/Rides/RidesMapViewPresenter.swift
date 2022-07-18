//
//  RidesMapViewPresenter.swift
//  XBike
//
//  Created by Leandro.Demarco on 13/07/2022.
//

import Foundation
import CoreLocation

protocol RidesMapViewProtocol: AnyObject {
    func drawRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D)
    func drawPoint(at: CLLocationCoordinate2D)
}

class XBikeRidesMapViewPresenter: RidesMapViewPresenter {
    private var startLocation: CLLocationCoordinate2D?
    private var endLocation: CLLocationCoordinate2D?
    weak var view: RidesMapViewProtocol?

    func getCurrentLocation() -> CLLocationCoordinate2D {
        // Ideally this should actually fetch user's current location
        // but due to time constraints I'm just hardcoding it
        CLLocationCoordinate2D(latitude: -31.394382557558735, longitude: -64.2223478897812)
    }

    func startNewRoute() {
        startLocation = nil
        endLocation = nil
    }

    func tappedLocation(_ location: CLLocationCoordinate2D) {
        if startLocation == nil {
            startLocation = location
            view?.drawPoint(at: location)
        } else if endLocation == nil {
            endLocation = location
            view?.drawPoint(at: location)
            view?.drawRoute(from: startLocation!, to: endLocation!)
        }
    }
}
