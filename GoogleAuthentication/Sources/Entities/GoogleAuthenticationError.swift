//
//  GoogleAuthenticationError.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-13.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import GoogleSignIn

public enum GoogleAuthenticationError: Error {
    /// Indicates the user canceled the sign in request.
    case cancelled

    /// Indicates an Enterprise Mobility Management related error has occurred.
    case emm

    /// Indicates there is an operation on a previous user.
    case mismatchWithCurrentUser

    /// Indicates missing sign in result.
    case missingResult

    /// Indicates missing token.
    case missingToken

    /// Indicates missing user.
    case missingUser

    /// Indicates there are no valid auth tokens in the keychain. This error code will be returned by `restorePreviousSignIn`
    /// if the user has not signed in before or if they have since signed out.
    case hasNoAuthInKeychain

    /// Indicates a problem reading or writing to the application keychain.
    case keychain

    /// Indicates the requested scopes have already been granted to the currentUser.
    case scopesAlreadyGranted

    /// Indicates an unknown error has occurred.
    case unknown
}
