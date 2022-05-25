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
    
    open func requestFailWithError(identifier: Any, code: Int, data: NSDictionary, error: Error) {
        let errorRequestTimeOut = error as NSError
        
        if errorRequestTimeOut.code == -1005 {
            self.validateRetryFlow(
                identifier: identifier,
                code: code,
                data: data,
                error: error
            )
        }
        else {
            self.retryCounter = 0
            self.delegate?.requestFailWithError(identifier: identifier, code: code, data: data, error: error)
        }
    }
    
    open func parseJson(
        identifier: Any,
        code: Int,
        rawDic: NSDictionary,
        responseHeaders: [AnyHashable : Any]
    ) { }
}
