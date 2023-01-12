//
//  AppleIdCredentialState.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-10.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public enum AppleIdCredentialState: String {
    /// The user is authorized.
    case authorized

    /// The user hasn’t established a relationship with Sign in with Apple.
    case notFound

    /// The given user’s authorization has been revoked and they should be signed out.
    case revoked

    /// The app has been transferred to a different team, and you need to migrate the user’s identifier.
    case transferred

    /// unknown state
    case unknown
}
