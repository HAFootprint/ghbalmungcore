//
//  GHBaseCoreServiceTest.swift
//  ghbalmungcoreTests
//
//  Created by Javier Carapia on 16/12/21.
//

import XCTest

class GHBaseCoreServiceTest: XCTestCase {
    var expectation: XCTestExpectation?
    var isFailed = false

    /********************
     ** RESPONSE ERROR **
     ********************/
    func requestFailWithError(identifier: Any, code: Int, data: NSDictionary, error: Error) {
        self.expectation?.fulfill()

        if self.isFailed {
            XCTAssert(!error.localizedDescription.isEmpty)
        }
        else {
            XCTFail("\n::: Error: \(error.localizedDescription)")
        }
    }
}
