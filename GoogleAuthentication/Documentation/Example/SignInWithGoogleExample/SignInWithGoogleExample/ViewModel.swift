//
//  AuthenticationManager.swift
//  GoogleAuthenticationExample
//
//  Created by Sheikh Bayazid on 2023-01-13.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Combine
import Foundation
import GoogleAuthentication
import UIKit

final class ViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    private let googleAuthentication = GoogleAuthentication()

    @Published private(set) var authToken: String?

    func handleOpenAppURL(_ url: URL) {
        googleAuthentication.handleOpenURL(url)
    }

    func restorePreviousSignIn() {
        googleAuthentication.restorePreviousSignIn()
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

        googleAuthentication.signIn(controller: rootViewController)
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
        googleAuthentication.signOut()
        authToken = nil
    }
}
