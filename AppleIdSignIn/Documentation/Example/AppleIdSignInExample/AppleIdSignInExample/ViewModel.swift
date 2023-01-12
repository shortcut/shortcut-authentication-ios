//
//  ViewModel.swift
//  AppleIdSignInExample
//
//  Created by Sheikh Bayazid on 2023-01-10.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import AppleIdSignIn
import Combine
import Foundation

class ViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    private let appleIdSignIn = AppleIdSignIn()

    @Published private(set) var authToken = ""
    @Published private(set) var credentialState = AppleIdCredentialState.notFound
    @Published private(set) var error: String?

    @Published private(set) var userId: String?

    init() {
        listenToCredentialState()
    }

    func signInWithApple() {
        appleIdSignIn.authenticate()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            } receiveValue: { [weak self] token in
                self?.authToken = token
                self?.error = nil
            }
            .store(in: &cancellables)
    }

    private func listenToCredentialState() {
        appleIdSignIn.credentialStatePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
            } receiveValue: { [weak self] state in
                self?.credentialState = state
            }
            .store(in: &cancellables)
    }

    func signInWithAppleWithCredentials() {
        appleIdSignIn.authenticate()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            } receiveValue: { [weak self] credential in
                guard let email = credential.email,
                      let fullName = credential.fullName?.description,
                      let givenName = credential.fullName?.givenName?.description,
                      let familyName = credential.fullName?.familyName?.description,
                      let identityToken = credential.identityToken,
                      let token = String(data: identityToken, encoding: .utf8) else {
                    return
                }

                let authorizedScopes = credential.authorizedScopes.map {
                    $0.hashValue.description
                }

                self?.userId = credential.user
                self?.authToken = token

                let _ = Model(
                    user: credential.user,
                    email: email,
                    fullName: fullName,
                    givenName: givenName,
                    familyName: familyName,
                    authorizedScopes: authorizedScopes,
                    authorizationCode: credential.authorizationCode,
                    token: token,
                    state: credential.state
                )

                // do operations with model
            }
            .store(in: &cancellables)
    }

    func getUserCredentialState(userId: String) {
        appleIdSignIn.getCredentialState(for: userId)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.credentialState = state

                if state == .authorized {
                    // Go to tab view
                }
            }
            .store(in: &cancellables)
    }
}

struct Model {
    let user: String
    let email: String

    let fullName: String
    let givenName: String
    let familyName: String

    let authorizedScopes: [String]
    let authorizationCode: Data?
    let token: String

    let state: String?
}
