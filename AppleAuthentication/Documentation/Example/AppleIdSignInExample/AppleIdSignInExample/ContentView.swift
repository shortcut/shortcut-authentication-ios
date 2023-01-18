//
//  ContentView.swift
//  AppleAuthenticationExample
//
//  Created by Sheikh Bayazid on 2023-01-10.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ViewModel()

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                if let error = vm.error {
                    Text("Error: \(error)")
                        .font(.headline)
                } else {
                    Text("Status: \(vm.credentialState.rawValue)")
                        .font(.headline)
                }

                Text(vm.authToken)
                    .minimumScaleFactor(0.4)
                    .frame(maxHeight: 250)
            }
            .padding()

            Button("Sign in with Apple") {
                vm.signInWithApple()
            }

            Button("Sign in with Apple with credentials") {
                vm.signInWithAppleWithCredentials()
            }

            if let userId = vm.userId {
                Button("Get current user's credential state") {
                    vm.getUserCredentialState(userId: userId)
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
