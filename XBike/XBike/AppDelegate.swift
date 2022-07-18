//
//  AppDelegate.swift
//  XBike
//
//  Created by Leandro.Demarco on 13/07/2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var onboardingNavigator: XBikeOnboardingNavigator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        onboardingNavigator = XBikeOnboardingNavigator(delegate: self)
        window = UIWindow(frame: UIScreen.main.bounds)

        let onboardingManager = XBikeOnboardingManager()
        if onboardingManager.shouldDisplayOnboarding() {
            refreshOnboardingContent()
        } else {
            showMainAppView()
        }

        // Only show onboarding on first launch after app install
        onboardingManager.stopShowingOnboarding()
        window?.makeKeyAndVisible()

        return true
    }

    private func showMainAppView() {
        let ridesStoryboard = UIStoryboard(name: "Rides", bundle: nil)
        let ridesViewController = ridesStoryboard.instantiateInitialViewController()
        window?.rootViewController = ridesViewController
    }

}

extension AppDelegate: OnboardingNavigatorDelegate {
    func refreshOnboardingContent() {
        let currentOnboardingPage = onboardingNavigator.currentPage()
        window?.rootViewController = currentOnboardingPage
    }

    func leaveOnboarding() {
        showMainAppView()
    }
}
