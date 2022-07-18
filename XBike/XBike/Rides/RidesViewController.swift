//
//  RidesViewController.swift
//  XBike
//
//  Created by Leandro.Demarco on 13/07/2022.
//

import UIKit

class RidesViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = .black

        if let ridesMapViewController = viewControllers?.first as? RidesMapViewController {
            ridesMapViewController.presenter = XBikeRidesMapViewPresenter()
        }
    }

}
