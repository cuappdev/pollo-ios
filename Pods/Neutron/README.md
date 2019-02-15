# Neutron
**Protocol-oriented networking in Swift with promises**

[![Version](https://img.shields.io/cocoapods/v/Neutron.svg?style=flat)](http://cocoapods.org/pods/Neutron)
[![Platform](https://img.shields.io/cocoapods/p/Neutron.svg?style=flat)](http://cocoapods.org/pods/Neutron)
[![License](https://img.shields.io/cocoapods/l/Neutron.svg?style=flat)](http://cocoapods.org/pods/Neutron)

## Introduction

Neutron is a wrapper around Alamofire that promotes protocol-oriented Swift networking.

Networking in Swift usually involves a tediously long list of static functions in a networking "manager" class, with each function doing repetitive calls to other functions. Worse, information about each request is often scattered across different places (routes may be in one enum, parameter keys may be in another, etc.). With Neutron, you define requests in structs called *Quarks*:

Defining a Quark:
```swift
struct Login: Quark {
    typealias ResponseType = User

    let username: String, password: String

    let route = "/login"
    var parameters: Parameters = [
        return [
            "user": username,
            "pass": password
        ]
    ]

    func process(response: Data) throws -> User {
        let user = ...
        return user
    }
}
```

Forming and making the request:
```swift
Login(username: "user", password: "****").make()
    .done { user in
        print("Got user:", user)
    }
    .catch { error in
        print(error)
    }
```

That's it. Since *Quark* is a protocol, structs and promises (see [PromiseKit](https://github.com/mxcl/PromiseKit)) make it easy to define, form, and perform the network request. Aside from default request data, everything about the request is contained in the struct.

Ultimately, Neutron improves upon the traditional network manager paradigm with:
- [x] Expressive, self-contained requests
- [x] Unverbose code due to default protocol implementations
- [x] Composability thanks to protocol inheritance
- [x] Auto-generated memberwise initializers for requests
- [x] Modular, organizable network requests

## Usage

### Defining Quarks

A Quark is a struct that conforms to the `Quark` protocol or a protocol which inherits from it:

```swift
import Neutron

struct MyQuark: Quark {
    <response type>
    <properties>
    <process method>
}
```

There are three parts to this, the order of which does not really matter:

#### 1. Define response type

In the struct, you should provide a typealias to `ResponseType` that specifies what kind of response you ultimately expect to be returned:

```swift
typealias ResponseType = MyModelClass
```

This will be the type that the `process` method (described below) must return and that the promise will return.

#### 2. List properties

List out the properties your request will require, careful not to override the protocol properties below. Swift automatically generates an initializer for these uninitialized properties. For instance, a request to renaming a to-do in a to-do list may required the id and title of the to-do:

```swift
let id: Int
let title: String
```
or
```swift
let id: Int, title: String
```

Use these properties to produce any of the following protocol properties to form the request:

**host:** `String` (default is "http://localhost")

**route:** `String` (no default - required)

**apiVersion:** `APIVersion` (default is `.none`)

**parameters:** `Parameters` (default is `[:]`)

**encoding:** `ParameterEncoding` (default is `URLEncoding.default`)

**headers:** `HTTPHeaders` (default is `[:]`)

If a property has a default, then it should be omitted when defining the request. In order to use your own properties in the request, **you need to use computed variables**:

```swift
var route: String {
    return "/todo/\(id)" // id defined earlier
}

var parameters: Parameters = [
    return [
        "title": title // title defined earlier
    ]
]
```

It is suffice to define other static properties as `let` properties. Note that if you do not initialize required protocol properties, they show up in the generated initializer.

#### 3. Process response

Lastly, implement the required `func process(response: Data) throws -> ResponseType` function. This method is called if the network request succeeds in order to convert the response body into the proper `ResponseType` as defined earlier. It is a `throw`ing method since the response data may not be as our client application expects.

With the to-do renaming example, if the server returns a JSON of the new todo, we might write the `process` method as such, using SwiftyJSON:
```swift
func process(response: Data) throws -> Todo {
    let json = JSON(data) // unnecessary, see 'Custom Quarks'
    guard let id: Int = json["id"].int,
        let title: String = json["title"].string else {
        throw NeutronError.badResponseData // throw error if unexpected data
    }

    return Todo(id: id, title: title, ... )
}
```

### Forming Quarks

Forming a request is as easy as calling the Swift-generated "memberwise" initializer:

```swift
RenameTodo(id: id, title: title)
```

Since requests are structs, they're storable, copyable, and modifiable:

```swift
let renameRequest = RenameTodo(id: id, title: title)
let copy = renameRequest
```

### Performing the Quark Requests

Finally, call the `make` function on the request, which returns a [PromiseKit](https://github.com/mxcl/PromiseKit) promise, and handle it accordingly:

```swift
RenameTodo(id: id, title: title).make()
    .done { todo in
        // use updated todo
        print(todo)
    }
    .catch { error in
        // catch any error that occurred
        print(error.localizedDescription)
    }
```

### Custom Quarks

It may be concerning that the default host for requests is `localhost`, and that the `process` method has a parameter of type `Data` and not something like `JSON`. This is where protocol composability comes in!

You can use the `JSONQuark` protocol for requests that are sure to return [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) JSON. With `JSONQuark`, the `response` parameter in the `process` method is of type `JSON` instead of `Data`.

You can provide your own protocol requirements and default implementations when you create your protocol that inherits from `Quark` or a sub-protocol of it, like `JSONQuark`:

```swift
protocol TodoQuark: Quark {
    var authToken: String { get } // every request should provide one
}

extension TodoQuark { // custom default implementations
    var host: String {
        return "https://my.todo.list.server"
    }

    var headers: HTTPHeaders = [
        "auth": authToken
    ]
}
```

Beautiful, no?

### Models

If we so choose, requests can be nested inside our models as RESTful resource requests:
```swift
class BlogPost { ... }
extension BlogPost {
    struct Get: Quark { ... }
    struct Post: Quark { ... }
    struct Delete: Quark { ... }
}

// Later...
BlogPost.Get(...)
BlogPost.Post(...)
BlogPost.Delete(...)
```

## Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Requires Swift 3.0 or above

## Installation

Neutron is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Neutron"
```

## Todo List
- [ ] README documentation
- [ ] Testing and CI
- [ ] Swift 2.x compatability
- [ ] More Quarks
- [ ] Configuration and documentation in Neutron.swift
- [ ] Remove dependencies and make them optional subspecs

## Author

This is a very young project, so forgive the mess and/or lack of functionality. That said, contributors would be great to have!

Daniel Li, dl743@cornell.edu

## License

Neutron is available under the MIT license. See the LICENSE file for more info.
