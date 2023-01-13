//
//  IGoogleIdSignIn.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-13.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

public protocol IGoogleIdSignIn {
    /// Handle the Google authentication redirect URL on GoogleSignIn button pressed
    /// - Parameter url: the Google redirect url
    func handleOpenAppURL(_ url: URL)

    /// On app start it tries and restore the sign-in state of users who already signed in using Google
    func restorePreviousSignIn() -> AnyPublisher<String, Error>

    /// Logs in a user
    /// - Parameter controller: the presenting viewController
    /// - Returns: A publisher of the user Google authentication token or an error
    func signIn(controller: UIViewController) -> AnyPublisher<String, Error>

    /// Signs out user
    func signOut()
}
