//
//  RideTimer.swift
//  XBike
//
//  Created by Leandro.Demarco on 18/07/2022.
//

import Foundation

protocol RideTimerDelegate: AnyObject {
    func timerTick()
}

protocol RideTimer {
    func start()
    func stop()
}

class DefaultRideTimer: RideTimer {
    weak var delegate: RideTimerDelegate?
    private var timer: Timer?

    init(delegate: RideTimerDelegate) {
        self.delegate = delegate
    }

    func start() {
        timer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.delegate?.timerTick()
        })
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
