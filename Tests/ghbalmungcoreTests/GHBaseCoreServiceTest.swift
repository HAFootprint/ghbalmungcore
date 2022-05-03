//
//  GHBaseCoreServiceTest.swift
//  ghbalmungcoreTests
//
//  Created by Javier Carapia on 16/12/21.
//

import XCTest
import Combine

class GHBaseCoreServiceTest: XCTestCase {
    var expectation: XCTestExpectation?
    var isFailed = false

    //MARK: RESPONSE ERROR
    func requestFailWithError(identifier: Any, code: Int, data: NSDictionary, error: Error) {
        self.expectation?.fulfill()

        if self.isFailed {
            XCTAssert(!error.localizedDescription.isEmpty)
        }
        else {
            XCTFail("\n::: Error: \(error.localizedDescription)")
        }
    }
    
    @available(iOS 13.0, *)
    func requestFail(completion: Subscribers.Completion<Error>) {
        switch completion {
            case .failure(let error):
                self.expectation?.fulfill()
                if self.isFailed {
                    XCTAssert(!error.localizedDescription.isEmpty)
                }
                else {
                    XCTFail("\n::: Error: \(error.localizedDescription)")
                }
            case .finished:
                break
        }
    }
}
