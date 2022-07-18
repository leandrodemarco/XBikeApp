//
//  StartRideView.swift
//  XBike
//
//  Created by Leandro.Demarco on 14/07/2022.
//

import UIKit

class StartRideView: UIView {
    private let timerLabel = UILabel()
    private let startLabel = UILabel()
    private let stopLabel = UILabel()
    private let separatorView = UIView()
    private let orangeColor = UIColor(named: "mainBackground")
    private let disabledColor = UIColor(named: "disabledTextColor")

    private let kTimerLabelInset: CGFloat = 16
    private let kControlLabelsWidth: CGFloat = 92
    private let kLabelsHeight: CGFloat = 21

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        separatorView.backgroundColor = orangeColor
        setupLabels()
        setupAutolayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAutolayout() {
        let subviews = [timerLabel, startLabel, stopLabel, separatorView]
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: kTimerLabelInset),
            timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -kTimerLabelInset),
            timerLabel.topAnchor.constraint(equalTo: topAnchor, constant: kTimerLabelInset),
            timerLabel.heightAnchor.constraint(equalToConstant: kLabelsHeight),

            separatorView.widthAnchor.constraint(equalToConstant: 1),
            separatorView.heightAnchor.constraint(equalToConstant: 56),
            separatorView.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 32),
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),

            startLabel.widthAnchor.constraint(equalToConstant: kControlLabelsWidth),
            startLabel.heightAnchor.constraint(equalToConstant: kLabelsHeight),
            startLabel.centerYAnchor.constraint(equalTo: separatorView.centerYAnchor),
            startLabel.trailingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: -8),

            stopLabel.widthAnchor.constraint(equalToConstant: kControlLabelsWidth),
            stopLabel.heightAnchor.constraint(equalToConstant: kLabelsHeight),
            stopLabel.centerYAnchor.constraint(equalTo: separatorView.centerYAnchor),
            stopLabel.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 8)
        ])
    }

    private func setupLabels() {
        let timerFont = UIFont(name: "Abel", size: 20)
        let controlFont = UIFont(name: "Abel", size: 18)

        timerLabel.font = timerFont
        startLabel.font = controlFont
        stopLabel.font = controlFont

        timerLabel.textAlignment = .center
        startLabel.textAlignment = .center
        stopLabel.textAlignment = .center

        timerLabel.textColor = .black
        startLabel.textColor = orangeColor
        stopLabel.textColor = disabledColor

        timerLabel.text = "00 : 00 : 00"
        startLabel.text = "Start"
        stopLabel.text = "Stop"
    }
}
