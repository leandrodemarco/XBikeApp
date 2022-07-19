//
//  RideSummaryView.swift
//  XBike
//
//  Created by Leandro.Demarco on 18/07/2022.
//

import UIKit

protocol RideSummaryViewPresenter {
    func deleteTapped()
    func storeTapped()
    var distanceString: String { get }
    var durationString: String { get }
    var rideDuration: TimeInterval { get }
}

/// View for displaying the duration and distance of the ride, allowing user to save it or discard it
class RideSummaryView: UIView {
    private let timeTitleLabel = UILabel()
    private let timeValueLabel = UILabel()
    private let distanceTitleLabel = UILabel()
    private let distanceValueLabel = UILabel()

    private let storeActionLabel = UILabel()
    private let actionSeparatorView = UIView()
    private let deleteActionLabel = UILabel()

    private let orangeColor = UIColor(named: "mainBackground")
    private let disabledColor = UIColor(named: "disabledTextColor")

    private let presenter: RideSummaryViewPresenter

    // MARK: Initialization
    init(
        frame: CGRect,
        presenter: RideSummaryViewPresenter
    ) {
        self.presenter = presenter
        super.init(frame: frame)
        setupAutolayout()
        setupActions()
        backgroundColor = .white
        layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Autolayout
    private let kLabelsHeight: CGFloat = 21
    private let kControlLabelsWidth: CGFloat = 92

    private func setupAutolayout() {
        let subviews = [timeTitleLabel, timeValueLabel, distanceTitleLabel, distanceValueLabel, storeActionLabel, actionSeparatorView, deleteActionLabel]
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        timeTitleLabel.text = "Your time was"
        distanceTitleLabel.text = "Distance"
        timeValueLabel.text = presenter.durationString
        distanceValueLabel.text = presenter.distanceString

        storeActionLabel.text = "Store"
        deleteActionLabel.text = "Delete"

        actionSeparatorView.backgroundColor = orangeColor
        storeActionLabel.textColor = orangeColor

        timeTitleLabel.textAlignment = .center
        timeValueLabel.textAlignment = .center
        distanceTitleLabel.textAlignment = .center
        distanceValueLabel.textAlignment = .center
        storeActionLabel.textAlignment = .center
        deleteActionLabel.textAlignment = .center

        let titleFont = UIFont(name: "Abel", size: 18)
        let valueFont = UIFont(name: "Abel", size: 24)
        let controlFont = UIFont(name: "Abel", size: 18)

        distanceTitleLabel.font = titleFont
        timeTitleLabel.font = titleFont
        distanceValueLabel.font = valueFont
        timeValueLabel.font = valueFont
        storeActionLabel.font = controlFont
        deleteActionLabel.font = controlFont

        NSLayoutConstraint.activate([
            timeTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            timeTitleLabel.heightAnchor.constraint(equalToConstant: kLabelsHeight),
            timeTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            timeTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            timeValueLabel.topAnchor.constraint(equalTo: timeTitleLabel.bottomAnchor, constant: 16),
            timeValueLabel.heightAnchor.constraint(equalToConstant: kLabelsHeight),
            timeValueLabel.leadingAnchor.constraint(equalTo: timeTitleLabel.leadingAnchor),
            timeValueLabel.trailingAnchor.constraint(equalTo: timeTitleLabel.trailingAnchor),

            distanceTitleLabel.topAnchor.constraint(equalTo: timeValueLabel.bottomAnchor, constant: 16),
            distanceTitleLabel.heightAnchor.constraint(equalToConstant: kLabelsHeight),
            distanceTitleLabel.leadingAnchor.constraint(equalTo: timeValueLabel.leadingAnchor),
            distanceTitleLabel.trailingAnchor.constraint(equalTo: timeValueLabel.trailingAnchor),

            distanceValueLabel.topAnchor.constraint(equalTo: distanceTitleLabel.bottomAnchor, constant: 8),
            distanceValueLabel.heightAnchor.constraint(equalToConstant: kLabelsHeight),
            distanceValueLabel.leadingAnchor.constraint(equalTo: distanceTitleLabel.leadingAnchor),
            distanceValueLabel.trailingAnchor.constraint(equalTo: distanceTitleLabel.trailingAnchor),

            actionSeparatorView.widthAnchor.constraint(equalToConstant: 1),
            actionSeparatorView.heightAnchor.constraint(equalToConstant: 56),
            actionSeparatorView.topAnchor.constraint(equalTo: distanceValueLabel.bottomAnchor, constant: 32),
            actionSeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor),

            // storeActionLabel.widthAnchor.constraint(equalToConstant: kControlLabelsWidth),
            storeActionLabel.leadingAnchor.constraint(equalTo: timeTitleLabel.leadingAnchor),
            storeActionLabel.heightAnchor.constraint(equalToConstant: kLabelsHeight),
            storeActionLabel.centerYAnchor.constraint(equalTo: actionSeparatorView.centerYAnchor),
            storeActionLabel.trailingAnchor.constraint(equalTo: actionSeparatorView.leadingAnchor, constant: -8),

            // deleteActionLabel.widthAnchor.constraint(equalToConstant: kControlLabelsWidth),
            deleteActionLabel.trailingAnchor.constraint(equalTo: timeTitleLabel.trailingAnchor),
            deleteActionLabel.heightAnchor.constraint(equalToConstant: kLabelsHeight),
            deleteActionLabel.centerYAnchor.constraint(equalTo: actionSeparatorView.centerYAnchor),
            deleteActionLabel.leadingAnchor.constraint(equalTo: actionSeparatorView.trailingAnchor, constant: 8)
        ])
    }

    // MARK: Actions
    private func setupActions() {
        storeActionLabel.isUserInteractionEnabled = true
        deleteActionLabel.isUserInteractionEnabled = true

        let storeTapGR = UITapGestureRecognizer()
        storeTapGR.addTarget(self, action: #selector(storeTapped))
        storeActionLabel.addGestureRecognizer(storeTapGR)

        let deleteTapGR = UITapGestureRecognizer()
        deleteTapGR.addTarget(self, action: #selector(deleteTapped))
        deleteActionLabel.addGestureRecognizer(deleteTapGR)
    }

    @objc private func storeTapped() {
        presenter.storeTapped()
    }

    @objc private func deleteTapped() {
        presenter.deleteTapped()
    }
}
