//
//  MyProgressViewPresenter.swift
//  XBike
//
//  Created by Leandro.Demarco on 18/07/2022.
//

import Foundation

class XBikeProgressViewPresenter: MyProgressViewPresenter {
    private let repository: RideRepository

    init(repository: RideRepository) {
        self.repository = repository
    }

    func getAllRides() -> [RideModel] {
        repository.listAll()
    }
}
