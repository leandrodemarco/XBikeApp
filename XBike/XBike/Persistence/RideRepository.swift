//
//  RideRepository.swift
//  XBike
//
//  Created by Leandro.Demarco on 14/07/2022.
//

import Foundation

protocol RideRepository {
    func save(_ ride: RideModel) -> Error?
    func listAll() -> [RideModel]
}
