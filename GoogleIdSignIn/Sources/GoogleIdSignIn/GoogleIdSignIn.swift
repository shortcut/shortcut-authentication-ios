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
    public var currentUser: GIDGoogleUser? {
        GIDSignIn.sharedInstance.currentUser
    }

    public init() { }

    public func handleOpenAppURL(_ url: URL)  {
        GIDSignIn.sharedInstance.handle(url)
    }

    public func restorePreviousSignIn() -> AnyPublisher<String, GoogleIdSignInError> {
        Future { promise in
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error = error as? GIDSignInError {
                    promise(.failure(error.asGoogleIdSignInError()))
                    return
                }

                guard let user = user, let token = user.idToken?.tokenString else {
                    promise(.failure(GoogleIdSignInError.missingUser))
                    return
                }

                promise(.success(token))
            }
        }
        .eraseToAnyPublisher()
    }

    public func signIn(controller: UIViewController) -> AnyPublisher<String, GoogleIdSignInError> {
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

                result.user.refreshTokensIfNeeded { user, error in
                    if let user = user, let idToken = user.idToken {
                        promise(.success(idToken.tokenString))
                        return
                    }
                    promise(.failure(GoogleIdSignInError.missingUser))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
