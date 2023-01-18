//
//  GoogleAuthenticationExampleApp.swift
//  GoogleAuthenticationExample
//
//  Created by Sheikh Bayazid on 2023-01-13.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import SwiftUI

@main
struct GoogleAuthenticationExampleApp: App {
    @StateObject private var vm = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: vm.handleOpenAppURL)
                .onAppear(perform: vm.restorePreviousSignIn)
                .environmentObject(vm)
        }
    }
}
