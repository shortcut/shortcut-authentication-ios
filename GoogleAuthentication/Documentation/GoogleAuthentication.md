# Google Authentication
Shortcut Authentication provides a convenient way to sign in user with Google using GoogleSignIn and Combine.

## Important
Before you start using this package, you'll need to complete these following steps in-order to make it work in your project.

1. Get OAuth client ID from [Google](https://developers.google.com/identity/sign-in/ios/start-integrating#get_an_oauth_client_id)
2. Add the OAuth client ID as GIDClientID and reversed OAuth client ID as URLSchemes in your project info.plist file.

To see an example go to [Google Documentation](https://developers.google.com/identity/sign-in/ios/start-integrating#configure_app_project) or checkout the [example](Example) project.

## Usage
Once these steps are complete, you can start adding the support for GoogleAuthentication.

### Create an instance of GoogleAuthentication:
```
private let googleAuthentication = GoogleAuthentication()
```

###  Handle the authentication redirect URL:
In your app's window or scene, register a handler to receive the URL and call `handleOpenURL(_:)`.

```
func handleOpenAppURL(_ url: URL) {
    googleAuthentication.handleOpenURL(url)
}
```
    
### Restore previous sign in:
If you'd like to restore your user on appear of your app's window, call `restorePreviousSignIn()` on onAppear of the app's window view:

```
func restorePreviousSignIn() {
    googleAuthentication.restorePreviousSignIn()
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
    
Calling the `handleOpenAppURL(_:)` and `restorePreviousSignIn()` in App's window:
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

### Sign in with Google:
Sign in a user using `signIn(controller:)`. It returns a token as a `String` as well as `GIDGoogleUser` and `GIDSignInResult`.
```
guard let rootViewController = UIApplication.shared.rootViewController else {
    return
}

googleAuthentication.signIn(controller: rootViewController)
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

### Restore token if needed:
If you'll need to refresh the user use `refreshTokenIfNeeded(user:)` and pass the user, it returns the refreshed user.

```
guard let user = user else {
    return
}

googleAuthentication.refreshTokenIfNeeded(user: user)
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
