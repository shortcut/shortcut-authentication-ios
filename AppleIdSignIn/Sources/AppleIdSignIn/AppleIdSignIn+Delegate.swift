//
//  AppleIdSignIn+Delegate.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-11.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import AuthenticationServices

extension AppleIdSignIn: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            logInWithAppleIdCredentialPublisher?.send(appleIDCredential)
            credentialStateSubject.send(.authorized)

        default:
            logInWithAppleIdCredentialPublisher?.send(completion: .failure(.failedToRetrieveCredentials))
        }
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if case ASAuthorizationError.canceled = error {
            logInWithAppleIdCredentialPublisher?.send(completion: .failure(.cancelled))
            return
        }
        logInWithAppleIdCredentialPublisher?.send(completion: .failure(.other(error)))
    }
}
