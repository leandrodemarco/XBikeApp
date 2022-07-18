//
//  OnboardingNavigator.swift
//  XBike
//
//  Created by Leandro.Demarco on 13/07/2022.
//

protocol OnboardingNavigator: AnyObject {
    var numberOfPages: UInt { get }
    func currentPage() -> OnboardingPageViewController
    func goToNextPage()
    func goToPreviousPage()
    func skipOnboarding()
}

protocol OnboardingNavigatorDelegate: AnyObject {
    func refreshOnboardingContent()
    func leaveOnboarding()
}

class XBikeOnboardingNavigator: OnboardingNavigator {
    private(set) var numberOfPages: UInt = 3
    private var currentPageIdx = 0
    private weak var delegate: OnboardingNavigatorDelegate?

    init(delegate: OnboardingNavigatorDelegate) {
        self.delegate = delegate
    }

    private let pageModels: [OnboardingPageModel] = [
        OnboardingPageModel(imageName: nil,
                            title: "Extremely simple to use",
                            nextButtonShown: true,
                            previousButtonShown: false
                           ),

        OnboardingPageModel(imageName: nil,
                            title: "Track your time and distance",
                            nextButtonShown: true,
                            previousButtonShown: true
                           ),

        OnboardingPageModel(imageName: nil,
                            title: "See your progress and challenge yourself!",
                            nextButtonShown: false,
                            previousButtonShown: true
                           )
    ]

    func currentPage() -> OnboardingPageViewController {
        OnboardingPageViewController(model: pageModels[currentPageIdx], navigator: self)
    }

    func goToNextPage() {
        guard currentPageIdx + 1 < pageModels.count else { return }
        currentPageIdx += 1
        delegate?.refreshOnboardingContent()
    }

    func goToPreviousPage() {
        guard currentPageIdx - 1 >= 0 else { return }
        currentPageIdx -= 1
        delegate?.refreshOnboardingContent()
    }

    func skipOnboarding() {
        delegate?.leaveOnboarding()
    }
}
