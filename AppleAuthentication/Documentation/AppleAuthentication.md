# AppleID SignIn
Shortcut Authentication provides a convenient way to authenticate user with AppleID using AuthenticationServices and Combine.

## Usage
To authenticate user with AppleID, use IAppleAuthentication protocol which provides the functionalities to login user with AppleID.
Before you start using this package, you'll need to add **_Sign in with Apple_** capability to your project, otherwise it will not work.

Create an instance of IAppleAuthentication. If you would like to listen to the account revoke notification from users iCloud account you'll need to keep the instance alive.
```
private let appleAuthentication = AppleAuthentication()
```
Authenticate with AppleID. `authenticate()` returns token as a `String` as well as `ASAuthorizationAppleIDCredential`. You can also pass `requestedScopes` as a parameter, default requested scopes are fullName and email.
```
appleAuthentication.authenticate()
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
Get the Apple Id credential state from given user id. `AppleIdCredentialSate` is an enum which represents the states of AppleID credentials. For example,  `.authorize` or `.revoked`.
```
appleAuthentication.getCredentialState(for: userId)
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
Listen to the changes of the `credentialStatePublisher` and if the state is revoked, it's recommended to log out the user but it's not obligated by Apple.
```
appleAuthentication.credentialStatePublisher
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
