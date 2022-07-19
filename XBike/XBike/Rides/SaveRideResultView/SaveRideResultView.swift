//
//  SaveRideResultView.swift
//  XBike
//
//  Created by Leandro.Demarco on 19/07/2022.
//

import UIKit

protocol SaveRideResultViewDelegate: AnyObject {
    func okTapped()
}

class SaveRideResultView: UIView {
    private let messageLabel = UILabel()
    private let okActionLabel = UILabel()
    private unowned let delegate: SaveRideResultViewDelegate?

    init(frame: CGRect, message: String, delegate: SaveRideResultViewDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        setupAutolayout()
        configureLabels(message: message)
        configureAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLabels(message: String) {
        messageLabel.text = message
        okActionLabel.text = "Ok"
        messageLabel.font = UIFont(name: "Abel", size: 18)
        okActionLabel.font = UIFont(name: "Abel", size: 16)
        messageLabel.textAlignment = .center
        okActionLabel.textAlignment = .center
        okActionLabel.textColor = UIColor(named: "mainBackground")
    }

    private func setupAutolayout() {
        addSubview(messageLabel)
        addSubview(okActionLabel)

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        okActionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageLabel.heightAnchor.constraint(equalToConstant: 42),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            okActionLabel.heightAnchor.constraint(equalToConstant: 21),
            okActionLabel.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
            okActionLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor),
            okActionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    private func configureAction() {
        let okTapGR = UITapGestureRecognizer()
        okActionLabel.isUserInteractionEnabled = true
        okTapGR.addTarget(self, action: #selector(okTapped))
        okActionLabel.addGestureRecognizer(okTapGR)
    }

    @objc private func okTapped() {
        delegate?.okTapped()
    }
}
