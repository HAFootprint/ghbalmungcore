//
//  GHURLSessionRxCoreManager.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 15/12/21.
//

import UIKit
import Combine
import ghgungnircore

enum NetworkErrors: Error {
    case badContent
    case connectionNoDetected(error: Error)
}

@available(iOS 13.0, *)
class GHURLSessionRxCoreManager: GHBaseCoreManager, URLSessionDelegate {
    private lazy var _dcConnection: [String: URLSession]? = [:]
    private var subscriber: AnyCancellable?
    
    override func submitRequest(
        bundle: Bundle,
        metadata: GHMetadataModel,
        restMethod: GHRestType
    ) -> AnyPublisher<Any, Error>? {
        
        if GHDependencyConfigManager.getStatusNetwork {
            if let nsurl = URL(string: metadata.url) {
                let request = self.interceptRequest(
                    bundle: bundle,
                    metadata: metadata,
                    restMethod: restMethod,
                    url: nsurl
                )
                
                let identifier = String(describing: metadata.type)
                
                if metadata.forceInvalidateAndCancel {
                    _dcConnection?[identifier]?.invalidateAndCancel()
                    _dcConnection?[identifier] = nil
                }
                
                _dcConnection?[identifier] = URLSession(
                    configuration: .default,
                    delegate: self,
                    delegateQueue: OperationQueue()
                )
                
                return _dcConnection![identifier]!.dataTaskPublisher(for: request)
                    .tryMap({ (data, response) -> (Data, URLResponse) in
                        return (data, response)
                    })
                    .eraseToAnyPublisher()
            }
        }
        
        return Fail(
            error: URLSession.DataTaskPublisher.Failure(
                .cannotConnectToHost,
                userInfo: [
                    NSLocalizedDescriptionKey : GHBalmungCoreLocalization.connectionNotDetected.localize(bundle: bundle)
                ]
            )
        ).eraseToAnyPublisher()
    }
}
