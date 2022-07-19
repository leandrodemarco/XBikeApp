//
//  RidesMapViewPresenter.swift
//  XBike
//
//  Created by Leandro.Demarco on 13/07/2022.
//

import Foundation
import CoreLocation
import MapKit

protocol RidesMapViewProtocol: AnyObject {
    func drawRoute(routePolyline: MKPolyline)
    func drawPoint(at: CLLocationCoordinate2D)
}

class XBikeRidesMapViewPresenter: RidesMapViewPresenter {
    private(set) var startLocation: CLLocationCoordinate2D?
    private(set) var endLocation: CLLocationCoordinate2D?
    private(set) var distance: Double = 0
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
            calculateRoute()
        }
    }

    private func calculateRoute() {
        guard let startLocation = startLocation,
              let endLocation = endLocation
        else {
            return
        }

        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: startLocation))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: endLocation))
        directionsRequest.transportType = .walking

        let directions = MKDirections(request: directionsRequest)
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            if let error = error {
                print("Error calculating directions: \(error)")
                return
            }

            if let route = response?.routes.first {
                self.distance = route.distance
                self.view?.drawRoute(routePolyline: route.polyline)
            }
        }
    }
}
