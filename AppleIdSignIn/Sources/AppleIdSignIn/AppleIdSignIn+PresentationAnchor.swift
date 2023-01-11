//
//  AppleIdSignIn+PresentationAnchor.swift
//  ShortcutAuthentication
//
//  Created by Sheikh Bayazid on 2023-01-11.
//  Copyright © 2023 Shortcut Scandinavia Apps AB. All rights reserved.
//

import AuthenticationServices

extension AppleIdSignIn: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow ?? ASPresentationAnchor()
    }
}
