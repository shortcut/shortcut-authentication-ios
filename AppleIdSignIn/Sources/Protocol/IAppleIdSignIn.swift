//
//  IAppleIdSignIn.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-10.
//

import AuthenticationServices
import Combine
import Foundation

public protocol IAppleIdSignIn {
    /// Apple id credential state publisher.
    var credentialStatePublisher: AnyPublisher<AppleIdCredentialState, Error> { get }

    /// Checks the Apple Id credential state from given user id.
    /// - Parameter userId: User id
    /// - Returns: A publisher of success AppleIdCredentialState or error
    func checkCredentialState(for userId: String) -> AnyPublisher<AppleIdCredentialState, Error>

    /// Logs in user with AppleId.
    /// - Returns: A publisher of success token or AppleIdAuthenticatorError
    func login(requestedScopes: [ASAuthorization.Scope]?) -> AnyPublisher<String, AppleIdSignInError>

    /// Logs in user with AppleId.
    /// - Returns: A publisher of success ASAuthorizationAppleIDCredential or AppleIdAuthenticatorError
    func login(requestedScopes: [ASAuthorization.Scope]?) -> AnyPublisher<ASAuthorizationAppleIDCredential, AppleIdSignInError>
}

public extension IAppleIdSignIn {
    /// Logs in user with AppleId.
    /// - Parameter requestedScopes: The contact information to be requested from the user during authentication. Default values are fullName and email.
    /// - Returns: A publisher of success token or AppleIdAuthenticatorError
    func login(requestedScopes: [ASAuthorization.Scope]? = [.fullName, .email]) -> AnyPublisher<String, AppleIdSignInError> {
        login(requestedScopes: requestedScopes)
    }

    /// Logs in user with AppleId.
    /// - Parameter requestedScopes: The contact information to be requested from the user during authentication. Default values are fullName and email.
    /// - Returns: A publisher of success ASAuthorizationAppleIDCredential or AppleIdAuthenticatorError
    func login(requestedScopes: [ASAuthorization.Scope]? = [.fullName, .email]) -> AnyPublisher<ASAuthorizationAppleIDCredential, AppleIdSignInError> {
        login(requestedScopes: requestedScopes)
    }
}
