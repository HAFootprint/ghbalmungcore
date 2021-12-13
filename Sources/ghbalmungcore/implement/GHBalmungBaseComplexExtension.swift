//
//  GHBalmungBaseComplexExtension.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation

extension GHBalmungBase {
    //MARK: Complex Flow
    public func doPostFormDataInBackground(metadata: GHMetadataModel) {
        self.restMethod     = .POST_FORM_DATA(.empty, -1)
        self.metadata       = metadata
        self.retryCounter   = 0
        
        if let data = metadata.params as? Data {
            do {
                if let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any?] {
                    let boundary = "Boundary-\(UUID().uuidString)"
                    let body = self.createBody(parameters: dic, boundary: boundary)
                    var meta = metadata
                    meta.setParams(params: body)
                    _ = self.coreServiceDelegate?.submitRequest(
                        bundle: self.bundle,
                        metadata: meta,
                        restMethod: .POST_FORM_DATA(boundary, body.count)
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
    
    public func doPostFileFormDataInBackground(metadata: GHMetadataModel) {
        self.restMethod     = .POST_FILE_FORM_DATA(.empty, -1)
        self.metadata       = metadata
        self.retryCounter   = 0
        
        if let data = metadata.params as? Data {
            do {
                if let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any?] {
                    let boundary = "Boundary-\(UUID().uuidString)"
                    let body = self.createFileBody(parameters: dic, boundary: boundary)
                    var meta = metadata
                    meta.setParams(params: body)
                    _ = self.coreServiceDelegate?.submitRequest(
                        bundle: self.bundle,
                        metadata: meta,
                        restMethod: .POST_FILE_FORM_DATA(boundary, body.count)
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
    
    public func doPostUrlEncodedInBackground(metadata: GHMetadataModel) {
        self.restMethod     = .POST_URL_ENC
        self.metadata       = metadata
        self.retryCounter   = 0
        
        if let data = metadata.params as? Data {
            do {
                if let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any?] {
                    let parameterArray = dic.map { (key, value) -> String in
                        guard let value = value else { return .empty}
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
