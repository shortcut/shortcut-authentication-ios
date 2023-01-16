//
//  GIDSignInError.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-16.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import GoogleSignIn

extension GIDSignInError {
    /// Map GIDSignInError to GoogleIdSignInError
    func asGoogleIdSignInError() -> GoogleIdSignInError {
        switch code {
        case .keychain:
            return .keychain

        case .hasNoAuthInKeychain:
            return .hasNoAuthInKeychain

        case .canceled:
            return .cancelled

        case .EMM:
            return .emm

        case .scopesAlreadyGranted:
            return .scopesAlreadyGranted

        case .mismatchWithCurrentUser:
            return .mismatchWithCurrentUser

        default:
            return .unknown
        }
    }
}

