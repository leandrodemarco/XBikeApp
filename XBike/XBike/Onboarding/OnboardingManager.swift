//
//  OnboardingManager.swift
//  XBike
//
//  Created by Leandro.Demarco on 13/07/2022.
//

import Foundation

protocol OnboardingManager {
    func shouldDisplayOnboarding() -> Bool
    func stopShowingOnboarding()
}

class XBikeOnboardingManager: OnboardingManager {
    func shouldDisplayOnboarding() -> Bool {
        // true
        !UserDefaults.standard.bool(forKey: UserDefaultsKeys.dontShowOnboarding)
    }

    func stopShowingOnboarding() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.dontShowOnboarding)
    }
}
