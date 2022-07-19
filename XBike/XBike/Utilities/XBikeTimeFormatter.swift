//
//  XBikeTimeFormatter.swift
//  XBike
//
//  Created by Leandro.Demarco on 18/07/2022.
//

import Foundation

protocol TimeFormatter {
    func formatTime(_ durationInSeconds: TimeInterval) -> String
}

class XBikeTimeFormatter: TimeFormatter {
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
