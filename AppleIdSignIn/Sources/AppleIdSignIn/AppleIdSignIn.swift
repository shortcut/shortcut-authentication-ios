//
//  AppleIdSignIn.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-09.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import AuthenticationServices
import Combine

public class AppleIdSignIn: NSObject, IAppleIdSignIn {
    private var cancellables = Set<AnyCancellable>()

    var credentialStateSubject = PassthroughSubject<AppleIdCredentialState, Error>()
    var authAppleIdCredentialPublisher: PassthroughSubject<ASAuthorizationAppleIDCredential, AppleIdSignInError>?

    public lazy var credentialStatePublisher = credentialStateSubject.eraseToAnyPublisher()

    public override init() {
        super.init()
        listenToCredentialRevokedNotification()
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    // MARK: Authenticate

    /// Logs in user with AppleId.
    /// - Returns: A publisher of success token or AppleIdAuthenticatorError
    public func authenticate(requestedScopes: [ASAuthorization.Scope]?) -> AnyPublisher<String, AppleIdSignInError> {
        authenticate(requestedScopes: requestedScopes)
            .tryMap { credentials in
                guard
                    let tokenData = credentials.identityToken,
                    let token = String(data: tokenData, encoding: .utf8)
                else {
                    throw AppleIdSignInError.failedToRetrieveToken
                }
                return token
            }
            .mapError {
                $0 as? AppleIdSignInError ?? .failedToRetrieveToken
            }
            .eraseToAnyPublisher()
    }

    /// Logs in user with AppleId.
    /// - Parameter requestedScopes: The contact information to be requested from the user during authentication. Default values are fullName and email.
    /// - Returns: A publisher of success ASAuthorizationAppleIDCredential or AppleIdAuthenticatorError
    public func authenticate(requestedScopes: [ASAuthorization.Scope]?) -> AnyPublisher<ASAuthorizationAppleIDCredential, AppleIdSignInError> {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = requestedScopes

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()

        // We need to create a new subject every time, so when we get error our subscription to this publisher won't be broken
        let authAppleIdCredentialPublisher = PassthroughSubject<ASAuthorizationAppleIDCredential, AppleIdSignInError>()
        self.authAppleIdCredentialPublisher = authAppleIdCredentialPublisher

        // The events are sent from the delegate
        return authAppleIdCredentialPublisher.eraseToAnyPublisher()
    }

    // MARK: Get Credential State

    /// Get the passed user Apple Id credential state
    /// - Warning: The data is emitted by *credentialStatePublisher*
    /// - parameters:
    ///    - userId: The id of the user to check the credential state for
    /// - returns: A publisher with the credential state or an error
    public func getCredentialState(for userId: String) -> AnyPublisher<AppleIdCredentialState, Error> {
        ASAuthorizationAppleIDProvider()
            .getCredentialState(forUserID: userId) { credentialState, error in
                if let error = error {
                    self.credentialStateSubject.send(completion: .failure(error))
                    return
                }
                self.credentialStateSubject.send(credentialState.appleIdCredentialState)
            }

        return credentialStatePublisher
    }

    // MARK: - Credential Revoke Notification

    /// Listens to the current user Apple Id credential revoke notification.
    /// Triggers when user stops using AppleId for this app from their iCloud account .
    /// - Warning: The changes are emitted by *credentialStatePublisher*
    private func listenToCredentialRevokedNotification() {
        NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.credentialStateSubject.send(.revoked)
            }
            .store(in: &cancellables)
    }
}
