//
//  GHAlamoCoreManager.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation
import Alamofire
import ghgungnircore
import ghbalmungcore

public class GHAlamoCoreManager: GHBaseCoreManager {
    public override func submitRequest(bundle: Bundle, metadata: GHMetadataModel, restMethod: GHRestType) -> Bool {
        var messageError:String = .empty
        
        guard super.submitRequest(bundle: bundle, metadata: metadata, restMethod: restMethod) else {
            return true
        }
        
        if GHDependencyConfigManager.getStatusNetwork {
            self.certificate = metadata.certificateAuthority
            
            if URL(string: metadata.url) != nil {
                var headers = restMethod.contentType
                if let dic = metadata.headers, headers.isNotEmpty {
                    dic.forEach { headers[$0.key] = $0.value }
                }
                
                AF.request(
                    metadata.url,
                    method: HTTPMethod(rawValue: restMethod.rawString),
                    parameters: self.convertToDictionary(
                        data: metadata.params
                    ),
                    headers: HTTPHeaders(headers)
                ) { $0.timeoutInterval = GHDependencyConfigManager.timeOutInterval(
                    bundle: bundle
                ) }
                .response { response in
                    
                    let statusCode      = response.response?.statusCode ?? -1
                    let responseHeaders = response.response?.allHeaderFields ?? [:]
                    
                    if let error = response.error?.underlyingError {
                        self.delegate?.requestFailWithError(
                            identifier: metadata.type,
                            code: statusCode,
                            data: [:],
                            error: error
                        )
                        
                        return
                    }
                    
                    guard let responseData = response.data else {
                        self.delegate?.requestFailWithError(
                            identifier: metadata.type,
                            code: statusCode,
                            data: [:],
                            error: GHError.make(
                                message: GHBalmungCoreLocalization.notReceiveData.localize
                            )
                        )
                        
                        return
                    }
                    
                    if let typeRes: Any = self.getGenericObject(
                        restMethod: restMethod,
                        responseData: responseData
                    ) {
                        var dic: NSDictionary = [:]
                            
                        if let dc = typeRes as? NSDictionary {
                            dic = dc
                        }
                        else {
                            dic = ["gh_generic_key": typeRes]
                        }
                        
                        self.delegate?.receiveData(
                            identifier: metadata.type,
                            code: statusCode,
                            data: dic,
                            responseHeaders: responseHeaders
                        )
                    }
                }
                
                return true
            }
            
            messageError = GHBalmungCoreLocalization.invalidUrl.localize(
                bundle: bundle
            )
        }
        else {
            messageError = GHBalmungCoreLocalization.connectionNotDetected.localize(
                bundle: bundle
            )
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
        AF.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
        
        super.cancelAllRequest()
    }
}
