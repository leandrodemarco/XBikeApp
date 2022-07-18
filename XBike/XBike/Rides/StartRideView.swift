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

    private var rideTimer: Timer?
    private var rideDuration: TimeInterval = 0
    private let durationFormatter = DateComponentsFormatter()

    private let kTimerLabelInset: CGFloat = 16
    private let kControlLabelsWidth: CGFloat = 92
    private let kLabelsHeight: CGFloat = 21

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        separatorView.backgroundColor = orangeColor
        setupLabels()
        setupAutolayout()
        setupActions()

        durationFormatter.allowedUnits = [.hour, .minute, .second]
        durationFormatter.unitsStyle = .positional
        durationFormatter.zeroFormattingBehavior = .pad
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
        setLabel(startLabel, enabled: true)
        setLabel(stopLabel, enabled: false)

        timerLabel.text = "00 : 00 : 00"
        startLabel.text = "Start"
        stopLabel.text = "Stop"
    }

    // MARK: Start/Stop Actions
    private func setupActions() {
        let startTapGR = UITapGestureRecognizer()
        startTapGR.addTarget(self, action: #selector(startTapped))
        startLabel.addGestureRecognizer(startTapGR)

        stopLabel.isUserInteractionEnabled = false
        let stopTapGR = UITapGestureRecognizer()
        stopTapGR.addTarget(self, action: #selector(stopTapped))
        stopLabel.addGestureRecognizer(stopTapGR)
    }

    @objc private func startTapped() {
        setLabel(stopLabel, enabled: true)
        setLabel(startLabel, enabled: false)
        rideTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
    }

    @objc private func stopTapped() {
        setLabel(stopLabel, enabled: false)
        setLabel(startLabel, enabled: true)
        rideTimer?.invalidate()
        rideTimer = nil
    }

    @objc private func updateTimeLabel() {
        rideDuration += 1
        let timerString = durationFormatter.string(from: rideDuration)
        DispatchQueue.main.async {
            self.timerLabel.text = timerString
        }
    }

    private func setLabel(_ label: UILabel, enabled: Bool) {
        let color = enabled ? orangeColor : disabledColor
        label.textColor = color
        label.isUserInteractionEnabled = enabled
    }
}
