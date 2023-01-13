//
//  SignInWithGoogleExampleApp.swift
//  SignInWithGoogleExample
//
//  Created by Sheikh Bayazid on 2023-01-13.
//

import SwiftUI

@main
struct SignInWithGoogleExampleApp: App {
    @StateObject private var vm = ViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: vm.handleOpenAppURL(_:))
                .onAppear(perform: vm.restorePreviousSignIn)
                .environmentObject(vm)
        }
    }
}
