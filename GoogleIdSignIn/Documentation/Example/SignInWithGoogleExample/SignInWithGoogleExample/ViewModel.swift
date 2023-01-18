//
//  AuthenticationManager.swift
//  SignInWithGoogleExample
//
//  Created by Sheikh Bayazid on 2023-01-13.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Combine
import Foundation
import GoogleIdSignIn
import UIKit

final class ViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    private let googleIdSignIn = GoogleIdSignIn()

    @Published private(set) var authToken: String?

    func handleOpenAppURL(_ url: URL) {
        googleIdSignIn.handleOpenURL(url)
    }

    func restorePreviousSignIn() {
        googleIdSignIn.restorePreviousSignIn()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break

                case .failure(let error):
                    debugPrint(error)
                }
            } receiveValue: { [weak self] token in
                self?.authToken = token
            }
            .store(in: &cancellables)
    }

    func signIn() {
        guard let rootViewController = UIApplication.shared.rootViewController else {
            return
        }

        googleIdSignIn.signIn(controller: rootViewController)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break

                case .failure(let error):
                    debugPrint(error)
                }
            } receiveValue: { [weak self] token in
                self?.authToken = token
            }
            .store(in: &cancellables)
    }

    func signOut() {
        googleIdSignIn.signOut()
        authToken = nil
    }
}
