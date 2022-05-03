//
//  GHFavoriteFlowServiceTest.swift
//  ghbalmungcorePackageTests
//
//  Created by Javier Carapia on 16/12/21.
//

import XCTest
import Combine

@testable import ghbalmungcore

@available(iOS 13.0, *)
class GHFavoriteFlowServiceTest: GHBaseCoreServiceTest, GHBaseBalmungDelegate {
    private var _service: GHBalmungBase?
    private var subscriber: AnyCancellable?
    private var _bundle: Bundle? {
        return .module //Bundle(identifier: "ghbalmungcore")
    }
    
    private let urlStr = "https://gist.githubusercontent.com/aletomm90/7ff8e9a7c49aefd06a154fe097028d27/raw/c87e2e7d21313391d412420b4254c391aa68eeec/favorites.json"
    
    override func setUp() async throws {
        try await super.setUp()
        
        self.isFailed = false
        
        if let bun = _bundle {
            _service = try! GHBalmungBase(
                bundle: bun,
                identifierService: .URLRxSession
            )
            _service?.delegate = self
        }
        else {
            XCTFail("\n::: Error: Bundle not valid")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        _service?.removeReferenceContext()
        _service = nil
        self.expectation = nil
    }
    
    //MARK: FLOW SUCCESS
    func testGetFavoriteListSuccess() throws {
        self.expectation = expectation(description: "::: Get favorite list success :::")
        
        let metadataModel = GHMetadataModel(
            url: self.urlStr,
            type: 1009
        )
        
        self.subscriber = _service?.doInRxBackground(
            metadata: metadataModel,
            method: .GET
        )?
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: self.requestFail,
            receiveValue: {
                self.expectation?.fulfill()
                
                if let response = $0 as? GHResponseModel {
                    XCTAssertTrue(response.data.count > 0)
                }
                else {
                    XCTFail("\n::: Error: Response Model Not Valid")
                }
            }
        )
        
        self.waitForExpectations(timeout: 60.0, handler: nil)
    }
}
