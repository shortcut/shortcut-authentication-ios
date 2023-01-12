//
//  AppleIdSignInError.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-10.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public enum AppleIdSignInError: Error {
    /// Authentication cancelled by user
    case cancelled

    /// Failed to retrieve credentials
    case failedToRetrieveCredentials

    /// Failed to retrieve token
    case failedToRetrieveToken

    /// Other error
    case other(Error)
}
