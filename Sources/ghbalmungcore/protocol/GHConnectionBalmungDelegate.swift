//
//  GNConnectionBalmungDelegate.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation

public protocol GHConnectionBalmungDelegate: AnyObject {
    func receiveData(
        identifier: Any,
        code: Int,
        data: NSDictionary,
        responseHeaders: [
            AnyHashable : Any
        ]
    )
    
    func requestFailWithError(
        identifier: Any,
        code: Int,
        data: NSDictionary,
        error: Error
    )
    
    func parseJson(
        identifier: Any,
        code: Int,
        rawDic: NSDictionary,
        responseHeaders: [AnyHashable : Any]
    )
    
    func removeReferenceContext()
}

public extension GHConnectionBalmungDelegate {
    public func parseJson(
        identifier: Any,
        code: Int,
        rawDic: NSDictionary,
        responseHeaders: [AnyHashable : Any]
    ) { }
}
