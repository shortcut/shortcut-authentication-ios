//
//  ASAuthorizationAppleIDProviderCredentialState+.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-10.
//

import AuthenticationServices
import Foundation

extension ASAuthorizationAppleIDProvider.CredentialState {
    /// Map ASAuthorizationAppleIDProvider.CredentialState to AppleIdCredentialState
    var appleIdCredentialState: AppleIdCredentialState {
        switch self {
        case .authorized:
            return .authorized

        case .revoked:
            return .revoked

        case .notFound:
            return .notFound

        case .transferred:
            return .transferred

        @unknown default:
            return .unknown
        }
    }
}
