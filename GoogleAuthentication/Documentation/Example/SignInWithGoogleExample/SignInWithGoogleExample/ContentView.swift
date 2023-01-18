//
//  ContentView.swift
//  GoogleAuthenticationExample
//
//  Created by Sheikh Bayazid on 2023-01-13.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var vm: ViewModel

    var body: some View {
        NavigationView {
            VStack {
                Text(vm.authToken ?? "")
                    .minimumScaleFactor(0.4)
                    .frame(maxHeight: 250)

                Button("Sign in with Google") {
                    vm.signIn()
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign out") {
                        vm.signOut()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
