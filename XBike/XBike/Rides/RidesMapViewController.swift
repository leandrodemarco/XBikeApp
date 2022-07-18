//
//  RidesMapViewController.swift
//  XBike
//
//  Created by Leandro.Demarco on 13/07/2022.
//

import UIKit
import MapKit

protocol RidesMapViewPresenter {
    var view: RidesMapViewProtocol? { get set }
    func getCurrentLocation() -> CLLocationCoordinate2D
    func startNewRoute()
    func tappedLocation(_ location: CLLocationCoordinate2D)
}

class RidesMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    var presenter: RidesMapViewPresenter? {
        didSet { presenter?.view = self }
    }
    private let kRegionMeters: CLLocationDistance = 500
    private var routeRenderer: MKOverlayRenderer?
    private var presentedRideView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        goToCurrentLocation()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        mapView.addGestureRecognizer(tapGR)
    }

    private func goToCurrentLocation() {
        guard let presenter = presenter else {
            return
        }

        let currentLocation = presenter.getCurrentLocation()
        let region = mapView.regionThatFits(MKCoordinateRegion(center: currentLocation,
                                                               latitudinalMeters: kRegionMeters,
                                                               longitudinalMeters: kRegionMeters))
        mapView.setRegion(region, animated: true)
    }

    @IBAction private func addNewRouteButtonTapped() {
        for overlay in mapView.overlays {
            mapView.removeOverlay(overlay)
        }

        presenter?.startNewRoute()
        presentedRideView?.removeFromSuperview()
    }

    @objc private func mapTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: mapView)
        let location = mapView.convert(point, toCoordinateFrom: mapView)

        presenter?.tappedLocation(location)
    }

    private func displayNewRideView() {
        let newRideView = StartRideView(frame: .zero)
        view.addSubview(newRideView)
        newRideView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newRideView.heightAnchor.constraint(equalToConstant: 150),
            newRideView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newRideView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            newRideView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        presentedRideView = newRideView
    }
}

extension RidesMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            routeRenderer = routeRenderer(overlay)
            return routeRenderer!
        } else {
            return circleRenderer(overlay)
        }
    }

    private func routeRenderer(_ routeOverlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: routeOverlay)
        renderer.strokeColor = UIColor(named: "mainBackground")
        renderer.lineWidth = 5.0

        return renderer
    }

    private func circleRenderer(_ circleOverlay: MKOverlay) -> MKOverlayRenderer {
        let color = UIColor(named: "mainBackground")
        let renderer = MKCircleRenderer(overlay: circleOverlay)
        renderer.lineWidth = 1.0
        renderer.fillColor = color
        renderer.strokeColor = color

        return renderer
    }
}

extension RidesMapViewController: RidesMapViewProtocol {
    func drawRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
        directionsRequest.transportType = .walking

        let directions = MKDirections(request: directionsRequest)
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            if let error = error {
                print("Error calculating directions: \(error)")
                return
            }

            if let route = response?.routes.first {
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                DispatchQueue.main.async {
                    self.displayNewRideView()
                }
            }
        }
    }

    func drawPoint(at: CLLocationCoordinate2D) {
        let circle = MKCircle(center: at, radius: 5)
        mapView.addOverlay(circle)
    }
}
