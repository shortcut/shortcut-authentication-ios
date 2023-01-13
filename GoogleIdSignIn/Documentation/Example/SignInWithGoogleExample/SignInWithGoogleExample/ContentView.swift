//
//  ContentView.swift
//  SignInWithGoogleExample
//
//  Created by Sheikh Bayazid on 2023-01-13.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var vm: ViewModel

    var body: some View {
        VStack {
            Text(vm.authToken ?? "")
                .minimumScaleFactor(0.4)
                .frame(maxHeight: 250)

            Button("Sign in with Google") {
                vm.signIn()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
