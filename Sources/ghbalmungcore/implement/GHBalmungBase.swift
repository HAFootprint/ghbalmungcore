//
//  GHBalmungBase.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation
import ghgungnircore
import Combine

open class GHBalmungBase: GHConnectionBalmungDelegate {
    internal var metadata: GHMetadataModel!
    internal var restMethod: GHRestType!
    internal var retryCounter: Int = 0
    
    internal var coreServiceDelegate: GHCoreBalmungDelegate?
    internal lazy var defaultError = GHBalmungCoreLocalization.defaultError.errorLocalize
    
    public var delegate: GHBaseBalmungDelegate?
    public var bundle: Bundle!
    
    public init(bundle: Bundle, identifierService: GHCoreType) throws {
        let strClass = identifierService.getClass()
        
        guard let classCoreService = NSClassFromString(strClass) as? GHCoreBalmungDelegate.Type else {
            throw GHErrorCore.coreNotFound
        }
        
        self.coreServiceDelegate = classCoreService.init()
        
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
    
    @available(iOS 13.0, *)
    public func doInRxBackground(metadata: GHMetadataModel, method: GHRestType) -> AnyPublisher<Any, Error>? {
        return self.coreServiceDelegate?.submitRequest(
            bundle: self.bundle,
            metadata: metadata,
            restMethod: method
        )
    }
    
    public func removeReferenceContext() {
        self.coreServiceDelegate?.removeReferenceContext()
        self.coreServiceDelegate = nil
        
        self.delegate = nil
        
        self.metadata = nil
        self.restMethod = nil
    }
}
