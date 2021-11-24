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
                case .GET, .GET_XML, .POST, .PUT, .PATCH, .DELETE:
                    self.retryCounter = self.retryCounter + 1
                
                    self.doRetryInBackground(
                        metadata: self.metadata,
                        restMethod: self.restMethod
                    )
                case .POST_FORM_DATA, .POST_FILE_FORM_DATA:
                    self.retryCounter = self.retryCounter + 1
                
                    self.doRetryFormDataInBackground(
                        metadata: self.metadata,
                        restMethod: self.restMethod
                    )
                case .POST_URL_ENC:
                    self.retryCounter = self.retryCounter + 1
                
                    self.doRetryUrlEncodedInBackground(
                        metadata: self.metadata,
                        restMethod: self.restMethod
                    )
                case .none:
                    self.retryCounter = 0
                
                    self.delegate?.requestFailWithError(
                        identifier: identifier,
                        code: code,
                        data: data,
                        error: error
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
    
    private func doRetryFormDataInBackground(metadata: GHMetadataModel, restMethod: GHRestType) {
        if let data = metadata.params as? Data {
            do {
                if let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any?] {
                    let boundary = "Boundary-\(UUID().uuidString)"
                    var body: Data = Data()
                    
                    switch restMethod {
                        case .POST_FORM_DATA:
                            body = self.createBody(parameters: dic, boundary: boundary)
                        case .POST_FILE_FORM_DATA:
                            body = self.createFileBody(parameters: dic, boundary: boundary)
                        default:
                            break
                    }
                    
                    var meta = metadata
                    meta.setParams(params: body)
                    
                    _ = self.coreServiceDelegate?.submitRequest(
                        bundle: self.bundle,
                        metadata: meta,
                        restMethod: restMethod
                    )
                    return
                }
            }
            catch {
                self.defaultError = error as NSError
            }
        }
        
        self.requestFailWithError(identifier: metadata.type, code: -1, data: [:], error: defaultError)
    }
    
    private func doRetryUrlEncodedInBackground(metadata: GHMetadataModel, restMethod: GHRestType) {
        if let data = metadata.params as? Data {
            do {
                if let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any?] {
                    let parameterArray = dic.map { (key, value) -> String in
                        guard let value = value else { return .empty }
                        return "\(key)=\(value)"
                        //GIPSY: Revisar encoding
                        //"\(key)=\(self.percentEscapeString(any: value))"
                    }.filter { $0.isNotEmpty }
                    
                    let body = parameterArray.joined(separator: "&").data(using: .utf8)
                    var meta = metadata
                    meta.setParams(params: body)
                    
                    _ = self.coreServiceDelegate?.submitRequest(
                        bundle: self.bundle,
                        metadata: meta,
                        restMethod: .POST_URL_ENC
                    )
                    
                    return
                }
            }
            catch {
                self.defaultError = error as NSError
            }
        }
        
        self.requestFailWithError(identifier: metadata.type, code: -1, data: [:], error: defaultError)
    }
}
