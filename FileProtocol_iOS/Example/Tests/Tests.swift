// https://github.com/Quick/Quick

import Quick
import Nimble
import NaptimeFileProtocol

class TableOfContentsSpec: QuickSpec {
    override func spec() {
  
    }
}

extension FileManager {
    var documentURL: URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
}
