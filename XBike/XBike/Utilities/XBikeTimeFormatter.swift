//
//  XBikeTimeFormatter.swift
//  XBike
//
//  Created by Leandro.Demarco on 18/07/2022.
//

import Foundation

class XBikeTimeFormatter {
    private let durationFormatter = DateComponentsFormatter()

    init() {
        durationFormatter.allowedUnits = [.hour, .minute, .second]
        durationFormatter.unitsStyle = .positional
        durationFormatter.zeroFormattingBehavior = .pad
    }

    func formatTime(_ durationInSeconds: TimeInterval) -> String {
        durationFormatter.string(from: durationInSeconds) ?? ""
    }
}
