# FutureNova

FutureNova is our networking wrapper using Futures and Promises. Please ignore the name, it was made using a name generator. 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Customize the Endpoint struct for less repetition

```swift
Endpoint.config.scheme = "https"
Endpoint.config.host = "dog.ceo"
Endpoint.config.commonPath = "/api"
```

Then create your endpoints.

```swift
extension Endpoint {
    /// Grabs a random dog breed image
    static func randomDogBreed() -> Endpoint {
        return Endpoint(path: "/breeds/image/random")
    }
}
```

Finally, call your endpoint!

```swift
private let networking: Networking = URLSession.shared.request

private func getRandomImage() -> Future<RandomDogResponse> {
    return networking(Endpoint.randomDogBreed()).decode()
}

...

getRandomImage().observe { [weak self] result in
    switch result {
    case .value(let resp):
        self?.presentResponse(resp)
    case .error(let error):
        self?.presentError(with: error)
    }
}
```

## Requirements

No requirements! This is a bare-bones solution to networking.

## Installation

FutureNova is NOT available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FutureNova', :git => 'https://github.com/cuappdev/ios-networking.git'
```

## Author

Cornell AppDev, team@cornellappdev.com

https://www.swiftbysundell.com/posts/under-the-hood-of-futures-and-promises-in-swift?rq=Futures

## License

FutureNova is available under the MIT license. See the LICENSE file for more info.
