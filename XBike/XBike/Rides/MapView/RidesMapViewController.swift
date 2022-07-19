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

    var distance: Double { get }
    var startLocation: CLLocationCoordinate2D? { get }
    var endLocation: CLLocationCoordinate2D? { get }
}

class RidesMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addNewRouteButton: UIButton!

    var presenter: RidesMapViewPresenter? {
        didSet { presenter?.view = self }
    }
    private let kRegionMeters: CLLocationDistance = 1500
    private var routeRenderer: MKOverlayRenderer?
    private var presentedAccessoryView: UIView?

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

    private func clearRouteDrawing() {
        for overlay in mapView.overlays {
            mapView.removeOverlay(overlay)
        }
    }

    @IBAction private func addNewRouteButtonTapped() {
        addNewRouteButton.isEnabled = false
        presenter?.startNewRoute()
    }

    @objc private func mapTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: mapView)
        let location = mapView.convert(point, toCoordinateFrom: mapView)

        presenter?.tappedLocation(location)
    }

    private func displayNewRideView() {
        let newRideView = StartRideView(frame: .zero) { [weak self] rideDuration in
            self?.displayRideSummaryView(rideDuration)
        }
        view.addSubview(newRideView)
        newRideView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newRideView.heightAnchor.constraint(equalToConstant: 150),
            newRideView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newRideView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            newRideView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        presentedAccessoryView = newRideView
    }

    private func displayRideSummaryView(_ rideDuration: TimeInterval) {
        clearRouteDrawing()
        guard let distance = presenter?.distance else {
            return
        }

        presentedAccessoryView?.removeFromSuperview()
        let summaryPresenter = DefaultRideSummaryViewPresenter(delegate: self,
                                                               rideDuration: rideDuration,
                                                               rideDistance: distance,
                                                               startPoint: presenter?.startLocation,
                                                               endPoint: presenter?.endLocation,
                                                               rideRepository: CoreDataRideRepository.singleton,
                                                               timeFormatter: XBikeTimeFormatter(),
                                                               reverseGeoCoder: XBikeReverseGeoCoder())
        let summaryView = RideSummaryView(frame: .zero, presenter: summaryPresenter)
        view.addSubview(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            summaryView.heightAnchor.constraint(equalToConstant: 250),
            summaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            summaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            summaryView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        presentedAccessoryView = summaryView
    }

    private func displaySaveResultViewWithMessage(_ message: String) {
        presentedAccessoryView?.removeFromSuperview()
        let saveResultView = SaveRideResultView(frame: .zero, message: message, delegate: self)
        view.addSubview(saveResultView)
        displayAccessoryViewCentered(saveResultView)
    }

    private func displayAccessoryViewCentered(_ accessoryView: UIView) {
        presentedAccessoryView?.removeFromSuperview()
        view.addSubview(accessoryView)
        accessoryView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            accessoryView.heightAnchor.constraint(equalToConstant: 250),
            accessoryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            accessoryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            accessoryView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        presentedAccessoryView = accessoryView
    }

    private func dismissPresentedViewAndResetAddRouteButton() {
        addNewRouteButton.isEnabled = true
        presentedAccessoryView?.removeFromSuperview()
        presentedAccessoryView = nil
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
    func drawRoute(routePolyline: MKPolyline) {
        DispatchQueue.main.async {
            self.mapView.addOverlay(routePolyline, level: .aboveRoads)
            self.displayNewRideView()
        }
    }

    func drawPoint(at: CLLocationCoordinate2D) {
        let circle = MKCircle(center: at, radius: 5)
        mapView.addOverlay(circle)
    }
}

extension RidesMapViewController: RideSummaryViewPresenterDelegate {
    func rideSavedWithError(_ error: Error?) {
        var message = "Your progress has been correctly stored!"
        if let error = error {
            message = "Failed to save ride: \(error)"
        }
        displaySaveResultViewWithMessage(message)
    }

    func discardCurrentRide() {
        dismissPresentedViewAndResetAddRouteButton()
    }
}

extension RidesMapViewController: SaveRideResultViewDelegate {
    func okTapped() {
        dismissPresentedViewAndResetAddRouteButton()
    }
}
