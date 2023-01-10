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

    private let appleSignIn = AppleIdSignIn()

    @Published private(set) var authToken = ""
    @Published private(set) var credentialState = AppleIdCredentialState.notFound
    @Published private(set) var error: String?

    init() {
        listenToCredentialState()
    }

    func signInWithApple() {
        appleSignIn.authenticate()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            } receiveValue: { token in
                self.authToken = token
                self.error = nil
            }
            .store(in: &cancellables)
    }

    private func listenToCredentialState() {
        appleSignIn.credentialStatePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
            } receiveValue: { [weak self] state in
                self?.credentialState = state
            }
            .store(in: &cancellables)
    }
}
