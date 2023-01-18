# Sign In With Google
Shortcut Authentication provides a convenient way to sign in user with Google using GoogleSignIn and Combine.

## Important
Before you start using this package, you'll need to complete these following steps in-order to make it work in your project.

1. Get OAuth client ID from [Google](https://developers.google.com/identity/sign-in/ios/start-integrating)
2. Add the OAuth client ID as GIDClientID and reversed OAuth client ID as URLSchemes in your project info.plist file.
To see an example checkout the [example](Example) project.

## Usage
Once these steps are complete, you can start adding the support for SignInWithGoogle.

1. Create an instance of SignInWithGoogle:
```
private let googleIdSignIn = SignInWithGoogle()
```

2.  Handle the authentication redirect URL:
In your app's window or scene, register a handler to receive the URL and call handleOpenURL.

```
    func handleOpenAppURL(_ url: URL) {
        googleIdSignIn.handleOpenURL(url)
    }
```
    
3. Restore previous sign in:
If you're using SwiftUI, add a call to restorePreviousSignIn in onAppear for your initial view:

```
    func restorePreviousSignIn() {
        googleIdSignIn.restorePreviousSignIn()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break

                case .failure(let error):
                    debugPrint(error)
                }
            } receiveValue: { [weak self] token in
                self?.authToken = token
            }
            .store(in: &cancellables)
    }
```
    
4. Calling the handleOpenAppURL and restorePreviousSignIn in App's window:
```
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    handleOpenAppURL(url)
                }
                .onAppear {
                    restorePreviousSignIn()
                }
        }
```

5. Sign in with Google:
Sign in a user using `signIn(controller:)`. It returns a token as a `String` as well as `GIDGoogleUser` and `GIDSignInResult`.
```
    guard let rootViewController = UIApplication.shared.rootViewController else {
        return
    }

    googleIdSignIn.signIn(controller: rootViewController)
        .receive(on: RunLoop.main)
        .sink { completion in
            switch completion {
            case .finished:
                break

            case .failure(let error):
                debugPrint(error)
            }
        } receiveValue: { [weak self] token in
            self?.authToken = token
        }
        .store(in: &cancellables)
```

6. Restore token if needed:
If you'll need to refresh the user use `refreshTokenIfNeeded(user:)` and pass the user, it returns the refreshed user.

```
    guard let user = user else {
        return
    }

    googleIdSignIn.refreshTokenIfNeeded(user: user)
        .receive(on: RunLoop.main)
        .sink { completion in
            switch completion {
            case .finished:
                break

            case .failure(let error):
                debugPrint(error)
            }
        } receiveValue: { [weak self] user in
            self?.user = user
        }
        .store(in: &cancellables)
```

To find more see the [example](Example) project.
