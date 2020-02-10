[![Build Status](https://travis-ci.com/essentiaone/essentia-network-core-ios.svg?branch=develop)](https://travis-ci.com/essentiaone/essentia-network-core-ios)
[![Badge w/ Version](https://cocoapod-badges.herokuapp.com/v/essentia-network-core-ios/badge.png)](https://cocoadocs.org/docsets/essentia-network-core-ios)
[![Badge w/ Platform](https://cocoapod-badges.herokuapp.com/p/essentia-network-core-ios/badge.svg)](https://cocoadocs.org/docsets/essentia-network-core-ios)
[![Badge w/ Licence](https://cocoapod-badges.herokuapp.com/l/essentia-network-core-ios/badge.svg)](https://cocoadocs.org/docsets/essentia-network-core-ios)

# Network Core
Network core it is library which wraps NSURLRequest in an easy way.
## Usage
1. Make enum which inherited of RequestProtocol
```Swift
enum TestEndpoint: RequestProtocol {
var path: String {
    return "/todos/1"
}
var extraHeaders: [String : String]? {
    return nil
}
var parameters: [String : Any]? {
    return nil
}
var requestType: RequestType {
    return .get
}
var contentType: RequestContentType {
    return .json    
}
case one
}
```
2. Initialize `NetworkManager`
```Swift
let network = NetworkManager("https://jsonplaceholder.typicode.com")
```
3. Make request
```Swift
network.makeRequest(TestEndpoint.one) { (result: Result<String>) in
    print(result)
}
```
## License
Network Core is released under the [MIT License](https://github.com/essentiaone/essentia-network-core-ios/blob/develop/LICENSE).
