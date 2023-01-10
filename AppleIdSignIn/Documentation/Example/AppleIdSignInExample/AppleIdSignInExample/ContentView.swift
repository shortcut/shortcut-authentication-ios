//
//  ContentView.swift
//  AppleIdSignInExample
//
//  Created by Sheikh Bayazid on 2023-01-10.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                if let error = viewModel.error {
                    Text("Error: \(error)")
                        .font(.headline)
                } else {
                    Text("Status: \(viewModel.credentialState.rawValue)")
                        .font(.headline)
                }

                Text(viewModel.authToken)
                    .minimumScaleFactor(0.4)
                    .frame(maxHeight: 250)
            }
            .padding()

            Button("Sign in with Apple") {
                viewModel.signInWithApple()
            }

            Button("Sign in with Apple with credentials") {
                viewModel.signInWithAppleWithCredentials()
            }

            if let userId = viewModel.userId {
                Button("Get user Credentials state") {
                    viewModel.getUserCredentialState(userId: userId)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
