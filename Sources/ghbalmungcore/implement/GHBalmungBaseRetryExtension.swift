//
//  GHBalmungBaseRetryExtension.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation

extension GHBalmungBase {
    //MARK: Validate Flow
    internal func validateRetryFlow(identifier: Any, code: Int, data: NSDictionary, error: Error) {
        if self.retryCounter < self.metadata.retryCounter {
            switch self.restMethod {
                case .none:
                    self.retryCounter = 0
                
                    self.delegate?.requestFailWithError(
                        identifier: identifier,
                        code: code,
                        data: data,
                        error: error
                    )
                default:
                    self.doRetryInBackground(
                        metadata: self.metadata,
                        restMethod: self.restMethod
                    )
            }
        }
        else {
            self.retryCounter = 0
            
            self.delegate?.requestFailWithError(
                identifier: identifier,
                code: code,
                data: data,
                error: error
            )
        }
    }
    
    //MARK: Retry Flow
    private func doRetryInBackground(metadata: GHMetadataModel, restMethod: GHRestType) {
        _ = self.coreServiceDelegate?.submitRequest(
            bundle: self.bundle,
            metadata: metadata,
            restMethod: restMethod
        )
    }
}
