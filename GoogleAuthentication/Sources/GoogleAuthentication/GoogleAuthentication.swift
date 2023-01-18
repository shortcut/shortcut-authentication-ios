//
//  GoogleAuthentication.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-09.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Combine
import Foundation
import GoogleSignIn
import SwiftUI

public class GoogleAuthentication: IGoogleAuthentication {
    /// The `GIDGoogleUser` representing the current user or `nil` if there is no signed-in user.
    public var currentUser: GIDGoogleUser? {
        GIDSignIn.sharedInstance.currentUser
    }

    public init() { }

    /// Handles the Google authentication redirect URL.
    /// - Parameter url: The Google redirect url
    public func handleOpenURL(_ url: URL) {
        GIDSignIn.sharedInstance.handle(url)
    }

    /// Refresh the user’s access and ID tokens if they have expired or are about to expire.
    /// - Parameter user: GIDGoogleUser
    /// - Returns: A publisher of GIDGoogleUser or an error
    public func refreshTokenIfNeeded(user: GIDGoogleUser) -> AnyPublisher<GIDGoogleUser, GoogleAuthenticationError> {
        Future { promise in
            user.refreshTokensIfNeeded { user, error in
                if let error = error as? GIDSignInError {
                    promise(.failure(error.asGoogleAuthenticationError()))
                    return
                }

                guard let user = user else {
                    promise(.failure(GoogleAuthenticationError.missingResult))
                    return
                }

                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }

    /// Attempts to restore a previous user sign-in without interaction.
    /// - Returns: A publisher of the user Google authentication token or an error
    public func restorePreviousSignIn() -> AnyPublisher<String, GoogleAuthenticationError> {
        restorePreviousSignIn()
            .tryMap { user in
                if let token = user.idToken?.tokenString {
                    return token
                }

                throw GoogleAuthenticationError.missingUser
            }
            .mapError {
                $0 as? GoogleAuthenticationError ?? .missingUser
            }
            .eraseToAnyPublisher()
    }

    /// Attempts to restore a previous user sign-in without interaction.
    /// - Returns: A publisher of tGIDGoogleUser or an error
    public func restorePreviousSignIn() -> AnyPublisher<GIDGoogleUser, GoogleAuthenticationError> {
        Future { promise in
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error = error as? GIDSignInError {
                    promise(.failure(error.asGoogleAuthenticationError()))
                    return
                }

                guard let user = user else {
                    promise(.failure(GoogleAuthenticationError.missingUser))
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
    public func signIn(controller: UIViewController) -> AnyPublisher<String, GoogleAuthenticationError> {
        signIn(controller: controller)
            .tryMap { result in
                if let idToken = result.user.idToken?.tokenString {
                    return idToken
                }

                throw GoogleAuthenticationError.missingToken
            }
            .mapError {
                $0 as? GoogleAuthenticationError ?? .missingToken
            }
            .eraseToAnyPublisher()
    }

    /// Signs in a user.
    /// - Parameter controller: The presenting viewController
    /// - Returns: A publisher of GIDGoogleUser or an error
    public func signIn(controller: UIViewController) -> AnyPublisher<GIDGoogleUser, GoogleAuthenticationError> {
        signIn(controller: controller)
            .map { $0.user }
            .eraseToAnyPublisher()
    }

    /// Signs in a user.
    /// - Parameter controller: The presenting viewController
    /// - Returns: A publisher of GIDSignInResult or an error
    public func signIn(controller: UIViewController) -> AnyPublisher<GIDSignInResult, GoogleAuthenticationError> {
        Future { promise  in
            GIDSignIn.sharedInstance.signIn(withPresenting: controller) { signInResult, error in
                if let error = error as? GIDSignInError {
                    promise(.failure(error.asGoogleAuthenticationError()))
                    return
                }

                guard let result = signInResult else {
                    promise(.failure(GoogleAuthenticationError.missingResult))
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
