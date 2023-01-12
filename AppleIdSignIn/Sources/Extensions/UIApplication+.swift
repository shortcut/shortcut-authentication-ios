//
//  UIApplication+.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-10.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        // Get connected scenes
        UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first { $0 is UIWindowScene }
            // Get its associated windows
            .flatMap { $0 as? UIWindowScene }?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }

}
