//
//  AppleIdSignIn.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-09.
//

import AuthenticationServices
import Combine

public class AppleIdSignIn: NSObject, IAppleIdSignIn {
    private var cancellables = Set<AnyCancellable>()

    private var credentialStateSubject = PassthroughSubject<AppleIdCredentialState, Error>()
    private var logInWithAppleIdPublisher: PassthroughSubject<String, AppleIdSignInError>?

    public lazy var credentialStatePublisher = credentialStateSubject.eraseToAnyPublisher()

    public override init() {
        super.init()
        listenToCredentialRevokedNotification()
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    /// Logs in user with AppleId.
    /// - Returns: A publisher of success token or AppleIdAuthenticatorError
    public func login(requestedScopes: [ASAuthorization.Scope]?) -> AnyPublisher<String, AppleIdSignInError> {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = requestedScopes

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()

        let logInWithAppleIdPublisher = PassthroughSubject<String, AppleIdSignInError>()
        self.logInWithAppleIdPublisher = logInWithAppleIdPublisher

        // The events are sent from the delegate
        return logInWithAppleIdPublisher.eraseToAnyPublisher()
    }

    // MARK: Apple Id Credential State

    /// Checks the passed user Apple Id credential state
    /// - Warning: The data is emitted by *credentialStatePublisher*
    /// - parameters:
    ///    - userId: The id of the user to check the credential state for
    /// - returns: A publisher with the credential state or an error
    public func checkCredentialState(for userId: String) -> AnyPublisher<AppleIdCredentialState, Error> {
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

extension AppleIdSignIn: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:

            guard
                let tokenData = appleIDCredential.identityToken,
                let token = String(data: tokenData, encoding: .utf8)
            else {
                logInWithAppleIdPublisher?.send(completion: .failure(.failedToRetrieveToken))
                return
            }
            logInWithAppleIdPublisher?.send(token)
            credentialStateSubject.send(.authorized)

        default:
            logInWithAppleIdPublisher?.send(completion: .failure(.failedToRetrieveToken))
        }
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if case ASAuthorizationError.canceled = error {
            logInWithAppleIdPublisher?.send(completion: .failure(.cancelledByUser))
            return
        }
        logInWithAppleIdPublisher?.send(completion: .failure(.other(error)))
    }
}

extension AppleIdSignIn: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
