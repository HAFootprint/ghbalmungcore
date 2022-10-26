//
//  GHMetadataModel.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation

public class GHMetadataModel {
    public var url: String
    public var certificateAuthority: String?
    public var type: Any = 0
    public var forceSimulationFlow: Bool = false
    public var forceInvalidateAndCancel: Bool = true
    public var params: Any?
    public var headers: [String: String]?
    
    internal var jsonLocalName: String
    internal var saveSessionCookies: Bool
    internal var saveServerDate: Bool
    internal var retryCounter: Int = 0
    internal var forceTimeOutFlow: TimeInterval?
    
    public init () {
        self.url = ""
        self.jsonLocalName = ""
        self.saveSessionCookies = false
        self.saveServerDate = false
        
        self.certificateAuthority = nil
        self.params = nil
        self.headers = nil
        self.forceTimeOutFlow = nil
    }
    
    public init(url: String,
                type: Int,
                params: Any? = nil,
                headers: [String: String]? = nil,
                certificateAuthority: String = .empty,
                jsonLocalName: String = .empty,
                saveSessionCookies: Bool = false,
                saveServerDate: Bool = false,
                forceTimeOutFlow: TimeInterval? = nil
    ) {
        self.url = url
        self.type = type
        self.params = params
        self.headers = headers
        self.certificateAuthority = certificateAuthority
        self.jsonLocalName = jsonLocalName
        self.saveSessionCookies = saveSessionCookies
        self.saveServerDate = saveServerDate
        self.forceTimeOutFlow = forceTimeOutFlow
    }
    
    public func setHeaders(headers: [String: String]) {
        self.headers = headers
    }
    
    public func setParams(params: Any?) {
        self.params = params
    }
}
