//
//  File.swift
//  
//
//  Created by Javier Carapia on 18/05/22.
//

import Foundation

extension GHBalmungBase {
    //MARK: Delegates
    public func receiveData(identifier: Any, code: Int, data: NSDictionary, responseHeaders: [AnyHashable : Any]) {
        self.parseJson(
            identifier: identifier,
            code: code,
            rawDic: data,
            responseHeaders: responseHeaders
        )
    }
}
