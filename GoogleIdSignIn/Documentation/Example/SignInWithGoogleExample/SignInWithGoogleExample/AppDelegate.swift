//
//  AppDelegate.swift
//  SignInWithGoogleExample
//
//  Created by Sheikh Bayazid on 2023-01-13.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import GoogleSignIn
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }
}
