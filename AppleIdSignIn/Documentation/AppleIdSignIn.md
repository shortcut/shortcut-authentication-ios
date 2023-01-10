# AppleID SignIn
Shortcut Authentication provides a convenient way to authenticate user with AppleID using AuthenticationServices and Combine.

## Usage
To authenticate user with AppleID, use IAppleIdSignIn protocol which provides the functionalities to login user with AppleID.
Before you start using this package, you'll need to add Sign in with Apple capability to your project, otherwise it will not work.

Inject the AppleIdSignIn using [ShortcutFoundation](https://github.com/shortcut/shortcut-foundation-ios.git).(Injection is optional but if you would like to listen to the account revoke notification from users iCloud account you'll need to keep the instance alive and you'll need to inject AppleIdSignIn)
```
@Inject private var appleIdSignIn: IAppleIdSignIn
```
Authenticate with AppleID. `authenticate()` returns token as a `String` as well as `ASAuthorizationAppleIDCredential`.
```
    appleIdSignIn.authenticate()
        .receive(on: RunLoop.main)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.error = error.localizedDescription
            }
        } receiveValue: { [weak self] token in
            self.authToken = token
        }
        .store(in: &cancellables)
```
Get the Apple Id credential state from given user id.
```
    appleIdSignIn.getCredentialState(for: userId)
        .receive(on: RunLoop.main)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.error = error.localizedDescription
            }
        } receiveValue: { [weak self] state in
            self?.credentialState = state

            if state == .authorized {
                // Go to tab view
            }
        }
        .store(in: &cancellables)
```
Listen to the changes of the `credentialStatePublisher` and if state is revoke then logout user.
```
    appleIdSignIn.credentialStatePublisher
        .receive(on: RunLoop.main)
        .sink { _ in
        } receiveValue: { [weak self] state in
            if state == .revoked {
                // Logout user
            }
        }
        .store(in: &cancellables)
```

To find more see the [example](Example) project.
