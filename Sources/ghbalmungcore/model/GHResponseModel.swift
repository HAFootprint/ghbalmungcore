//
//  File.swift
//  
//
//  Created by Javier Carapia on 02/05/22.
//

import Foundation

public struct GHResponseModel {
    public var identifier: Any
    public var statusCode: Int
    public var data: NSDictionary
    public var responseHeaders: [AnyHashable : Any]
    
    public init(
        identifier: Any,
        statusCode: Int,
        data: NSDictionary,
        responseHeaders: [AnyHashable : Any]
    ) {
        self.identifier = identifier
        self.statusCode = statusCode
        self.data       = data
        self.responseHeaders = responseHeaders
    }
    
    public init() {
        self.identifier = -1
        self.statusCode = -1
        self.data       = NSDictionary()
        self.responseHeaders = [:]
    }
}
