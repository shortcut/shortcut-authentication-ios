//
//  GoogleIdSignIn.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-09.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Combine
import Foundation
import GoogleSignIn
import SwiftUI

public class GoogleIdSignIn: IGoogleIdSignIn {
    /// The `GIDGoogleUser` representing the current user or `nil` if there is no signed-in user.
    public var currentUser: GIDGoogleUser? {
        GIDSignIn.sharedInstance.currentUser
    }

    public init() { }

    /// Handles the Google authentication redirect URL.
    /// - Parameter url: The Google redirect url
    public func handleOpenAppURL(_ url: URL) {
        GIDSignIn.sharedInstance.handle(url)
    }

    /// Refresh the user’s access and ID tokens if they have expired or are about to expire.
    /// - Parameter user: GIDGoogleUser
    /// - Returns: A publisher of GIDGoogleUser or an error
    public func refreshTokenIfNeeded(user: GIDGoogleUser) -> AnyPublisher<GIDGoogleUser, GoogleIdSignInError> {
        Future { promise in
            user.refreshTokensIfNeeded { user, error in
                if let error = error as? GIDSignInError {
                    promise(.failure(error.asGoogleIdSignInError()))
                    return
                }

                guard let user = user else {
                    promise(.failure(GoogleIdSignInError.missingResult))
                    return
                }

                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }

    /// Attempts to restore a previous user sign-in without interaction.
    /// - Returns: A publisher of the user Google authentication token or an error
    public func restorePreviousSignIn() -> AnyPublisher<String, GoogleIdSignInError> {
        restorePreviousSignIn()
            .tryMap { user in
                if let token = user.idToken?.tokenString {
                    return token
                }

                throw GoogleIdSignInError.missingUser
            }
            .mapError {
                $0 as? GoogleIdSignInError ?? .missingUser
            }
            .eraseToAnyPublisher()
    }

    /// Attempts to restore a previous user sign-in without interaction.
    /// - Returns: A publisher of tGIDGoogleUser or an error
    public func restorePreviousSignIn() -> AnyPublisher<GIDGoogleUser, GoogleIdSignInError> {
        Future { promise in
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error = error as? GIDSignInError {
                    promise(.failure(error.asGoogleIdSignInError()))
                    return
                }

                guard let user = user else {
                    promise(.failure(GoogleIdSignInError.missingUser))
                    return
                }

                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }

    /// Signs in a user.
    /// - Parameter controller: The presenting viewController
    /// - Returns: A publisher of the user Google authentication token or an error
    public func signIn(controller: UIViewController) -> AnyPublisher<String, GoogleIdSignInError> {
        signIn(controller: controller)
            .tryMap { result in
                if let idToken = result.user.idToken?.tokenString {
                    return idToken
                }

                throw GoogleIdSignInError.missingToken
            }
            .mapError {
                $0 as? GoogleIdSignInError ?? .missingToken
            }
            .eraseToAnyPublisher()
    }

    /// Signs in a user.
    /// - Parameter controller: The presenting viewController
    /// - Returns: A publisher of GIDGoogleUser or an error
    public func signIn(controller: UIViewController) -> AnyPublisher<GIDGoogleUser, GoogleIdSignInError> {
        signIn(controller: controller)
            .map { $0.user }
            .eraseToAnyPublisher()
    }

    /// Signs in a user.
    /// - Parameter controller: The presenting viewController
    /// - Returns: A publisher of GIDSignInResult or an error
    public func signIn(controller: UIViewController) -> AnyPublisher<GIDSignInResult, GoogleIdSignInError> {
        Future { promise  in
            GIDSignIn.sharedInstance.signIn(withPresenting: controller) { signInResult, error in
                if let error = error as? GIDSignInError {
                    promise(.failure(error.asGoogleIdSignInError()))
                    return
                }

                guard let result = signInResult else {
                    promise(.failure(GoogleIdSignInError.missingResult))
                    return
                }

                promise(.success(result))
            }
        }
        .eraseToAnyPublisher()
    }

    /// Signs out the `currentUser`, removing it from the keychain.
    public func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
