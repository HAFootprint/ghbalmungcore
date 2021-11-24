//
//  GHBalmungBase.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation
import ghgungnircore

open class GHBalmungBase: GHConnectionBalmungDelegate {
    internal var metadata: GHMetadataModel!
    internal var restMethod: GHRestType!
    internal var retryCounter: Int = 0
    internal var coreServiceDelegate: GHCoreBalmungDelegate?
    
    internal lazy var defaultError = GHError.make(
        message: GHBalmungCoreLocalization.defaultError.localize
    )
    
    public var delegate: GHBaseBalmungDelegate?
    public var bundle: Bundle!
    
    public init(bundle: Bundle, identifierService: GHCoreType) {
        let strClass = String(
            format: "%@.%@",
            arguments: [
                "ghbalmungcore",
                identifierService.getClass()
            ]
        )
        
        if let classCoreService = NSClassFromString(strClass) as? GHCoreBalmungDelegate.Type {
            self.coreServiceDelegate = classCoreService.init()
        }
        
        self.coreServiceDelegate?.delegate = self
        self.bundle = bundle
    }
    
    //*************************
    //MARK: PUBLIC FUNCTIONS
    //*************************
    public func doInBackground(metadata: GHMetadataModel, method: GHRestType) {
        self.restMethod     = method
        self.metadata       = metadata
        self.retryCounter   = 0
        
        _ = self.coreServiceDelegate?.submitRequest(
            bundle: self.bundle,
            metadata: metadata,
            restMethod: method
        )
    }
    
    //MARK: Delegates
    public func receiveData(identifier: Any, code: Int, data: NSDictionary, responseHeaders: [AnyHashable : Any]) {
        self.parseJson(
            identifier: identifier,
            code: code,
            rawDic: data,
            responseHeaders: responseHeaders
        )
    }
    
    public func requestFailWithError(identifier: Any, code: Int, data: NSDictionary, error: Error) {
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
    
    public func removeReferenceContext() {
        self.coreServiceDelegate?.removeReferenceContext()
        self.coreServiceDelegate = nil
        
        self.delegate = nil
        
        self.metadata = nil
        self.restMethod = nil
    }
}
