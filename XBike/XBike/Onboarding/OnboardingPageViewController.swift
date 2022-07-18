//
//  OnboardingPageView.swift
//  XBike
//
//  Created by Leandro.Demarco on 13/07/2022.
//

import UIKit

class OnboardingPageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    @IBOutlet weak var skipLabel: UILabel!

    private let model: OnboardingPageModel
    weak var navigator: OnboardingNavigator?

    // MARK: Lifecycle
    init(
        model: OnboardingPageModel,
        navigator: OnboardingNavigator
    ) {
        self.model = model
        self.navigator = navigator
        super.init(nibName: "OnboardingPage", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageName = model.imageName {
            imageView.image = UIImage(named: imageName)
        }
        titleLabel.text = model.title
        configureNavigationLabels()
    }

    // MARK: Navigation
    private func configureNavigationLabels() {
        configureNextLabel()
        configurePreviousLabel()
        configureSkipLabel()
    }

    private func configureNextLabel() {
        guard model.nextButtonShown else {
            nextLabel.isHidden = true
            return
        }
        nextLabel.isUserInteractionEnabled = true
        let nextGR = UITapGestureRecognizer(target: self, action: #selector(nextLabelTapped))
        nextLabel.addGestureRecognizer(nextGR)
    }

    private func configurePreviousLabel() {
        guard model.previousButtonShown else {
            previousLabel.isHidden = true
            return
        }
        previousLabel.isUserInteractionEnabled = true
        let previousGR = UITapGestureRecognizer(target: self, action: #selector(previousLabelTapped))
        previousLabel.addGestureRecognizer(previousGR)
    }

    private func configureSkipLabel() {
        skipLabel.isUserInteractionEnabled = true
        let skipGR = UITapGestureRecognizer(target: self, action: #selector(skipLabelTapped))
        skipLabel.addGestureRecognizer(skipGR)
    }

    @objc private func skipLabelTapped() {
        navigator?.skipOnboarding()
    }

    @objc private func nextLabelTapped() {
        navigator?.goToNextPage()
    }

    @objc private func previousLabelTapped() {
        navigator?.goToPreviousPage()
    }
}
