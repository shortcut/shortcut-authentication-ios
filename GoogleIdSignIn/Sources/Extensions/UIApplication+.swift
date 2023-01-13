//
//  UIApplication+.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-13.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import UIKit

public extension UIApplication {
    /// The root view controller for the window.
    var rootViewController: UIViewController? {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
    }
}
