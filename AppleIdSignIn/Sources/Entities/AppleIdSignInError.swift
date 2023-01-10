//
//  AppleIdSignInError.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-10.
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

extension AppleIdSignInError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cancelled:
            return "Authentication Cancelled"
        case .failedToRetrieveToken:
            return "Failed to retrieve token"
        case .other(let error):
            return error.localizedDescription
        case .failedToRetrieveCredentials:
            return "Failed to retrieve credentials"
        }
    }
}
