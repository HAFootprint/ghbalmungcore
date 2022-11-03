//
//  GHURLSessionCoreManager.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation
import ghgungnircore
import ghbalmungcore

class GHURLSessionCoreManager: GHBaseCoreManager {
    public override func submitRequest(bundle: Bundle, metadata: GHMetadataModel, restMethod: GHRestType, restContentType: GHRestContentType) -> Bool {
        var messageError:String = .empty
        
        guard super.submitRequest(bundle: bundle, metadata: metadata, restMethod: restMethod, restContentType: restContentType) else {
            return true
        }
        
        if GHDependencyConfigManager.getStatusNetwork {
            self.certificate = metadata.certificateAuthority
            
            if let nsurl = URL(string: metadata.url) {
                let request = self.interceptRequest(
                    bundle: bundle,
                    metadata: metadata,
                    restMethod: restMethod,
                    contentType: restContentType,
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
                
                let task = _dcConnection?[identifier]?.dataTask(with: request, completionHandler: { (data, response, error) in
                    let tuple = self.interceptResponse(
                        response: response,
                        metadata: metadata
                    )
                    
                    if error != nil {
                        self.delegate?.requestFailWithError(
                            identifier: metadata.type,
                            code: tuple.statusCode,
                            data: [:],
                            error: error!
                        )
                        
                        return
                    }
                    
                    guard let responseData = data else {
                        self.delegate?.requestFailWithError(
                            identifier: metadata.type,
                            code: tuple.statusCode,
                            data: [:],
                            error: GHError.make(
                                message: GHBalmungCoreLocalization.notReceiveData.localize
                            )
                        )
                        
                        return
                    }
                    
                    if let typeRes: Any = self.getGenericObject(restMethod: restMethod, responseData: responseData) {
                        var dic: NSDictionary = [:]
                            
                        if let dc = typeRes as? NSDictionary {
                            dic = dc
                        }
                        else {
                            dic = [GHBalmungContants.genericKeyServiceResponse: typeRes]
                        }
                        
                        self.delegate?.receiveData(
                            identifier: metadata.type,
                            code: tuple.statusCode,
                            data: dic,
                            responseHeaders: tuple.responseHeaders
                        )
                    }
                })
                
                task?.resume()
                
                return true
            }
                
            messageError = GHBalmungCoreLocalization.invalidUrl.localize(bundle: bundle)
        }
        else {
            messageError = GHBalmungCoreLocalization.connectionNotDetected.localize(bundle: bundle)
        }
        
        self.delegate?.requestFailWithError(
            identifier: metadata.type,
            code: -1,
            data: [:],
            error: GHError.make(
                message: messageError
            )
        )
        
        return true
    }
    
    public override func cancelAllRequest() {
        _dcConnection?.forEach { $0.value.invalidateAndCancel() }
        _dcConnection?.removeAll()
        _dcConnection = nil
        
        super.cancelAllRequest()
    }
    
    public override func removeReferenceContext() {
        super.removeReferenceContext()
    }
}
