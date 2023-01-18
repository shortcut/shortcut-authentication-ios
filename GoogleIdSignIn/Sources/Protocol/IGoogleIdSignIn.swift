//
//  IGoogleIdSignIn.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-13.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Combine
import Foundation
import GoogleSignIn
import SwiftUI

public protocol IGoogleIdSignIn {
    /// The `GIDGoogleUser` representing the current user or `nil` if there is no signed-in user.
    var currentUser: GIDGoogleUser? { get }

    /// Handles the Google authentication redirect URL.
    /// - Parameter url: The Google redirect url
    func handleOpenURL(_ url: URL)

    /// Refresh the user’s access and ID tokens if they have expired or are about to expire.
    /// - Parameter user: GIDGoogleUser
    /// - Returns: A publisher of GIDGoogleUser or an error
    func refreshTokenIfNeeded(user: GIDGoogleUser) -> AnyPublisher<GIDGoogleUser, GoogleIdSignInError>

    /// Attempts to restore a previous user sign-in without interaction.
    /// - Returns: A publisher of the user Google authentication token or an error
    func restorePreviousSignIn() -> AnyPublisher<String, GoogleIdSignInError>

    /// Attempts to restore a previous user sign-in without interaction.
    /// - Returns: A publisher of GIDGoogleUser or an error
    func restorePreviousSignIn() -> AnyPublisher<GIDGoogleUser, GoogleIdSignInError>

    /// Signs in a user.
    /// - Parameter controller: The presenting viewController
    /// - Returns: A publisher of the user Google authentication token or an error
    func signIn(controller: UIViewController) -> AnyPublisher<String, GoogleIdSignInError>

    /// Signs in a user.
    /// - Parameter controller: The presenting viewController
    /// - Returns: A publisher of GIDGoogleUser or an error
    func signIn(controller: UIViewController) -> AnyPublisher<GIDGoogleUser, GoogleIdSignInError>

    /// Signs in a user.
    /// - Parameter controller: The presenting viewController
    /// - Returns: A publisher of GIDSignInResult or an error
    func signIn(controller: UIViewController) -> AnyPublisher<GIDSignInResult, GoogleIdSignInError>

    /// Signs out the `currentUser`, removing it from the keychain.
    func signOut()
}
