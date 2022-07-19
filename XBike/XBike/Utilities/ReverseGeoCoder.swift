//
//  ReverseGeoCoder.swift
//  XBike
//
//  Created by Leandro.Demarco on 19/07/2022.
//

import MapKit
import CoreLocation

protocol ReverseGeoCoder {
    func getStringAddressFrom(location: CLLocationCoordinate2D?, completion: @escaping (String) -> Void)
}

class XBikeReverseGeoCoder: ReverseGeoCoder {
    func getStringAddressFrom(location: CLLocationCoordinate2D?, completion: @escaping (String) -> Void) {
        var result = "unknown"
        guard let location = location else {
            completion(result)
            return
        }

        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        CLGeocoder().reverseGeocodeLocation(clLocation) { placemarks, error in
            if let placemark = placemarks?.first {
                if let street = placemark.thoroughfare {
                    result = street
                }
                if let number = placemark.subThoroughfare {
                    result += (" " + number)
                }
                if let city = placemark.locality {
                    result += (" " + city)
                }
            }
            completion(result)
        }
    }
}
