//
//  GHMetadataModel.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

public struct GHMetadataModel {
    let url: String
    let jsonLocalName: String
    let certificateAuthority: String?
    
    var params: Any?
    var headers: [String: String]?
    var saveSessionCookies: Bool
    var saveServerDate: Bool
    
    public var type: Any = 0
    
    public var forceSimulationFlow: Bool = false
    
    public var retryCounter: Int = 0
    public var forceInvalidateAndCancel: Bool = true
    
    public init(url: String,
                type: Int,
                params: Any? = nil,
                headers: [String: String]? = nil,
                certificateAuthority: String = .empty,
                jsonLocalName: String = .empty,
                saveSessionCookies: Bool = false,
                saveServerDate: Bool = false) {
        self.url = url
        self.type = type
        self.params = params
        self.headers = headers
        self.certificateAuthority = certificateAuthority
        self.jsonLocalName = jsonLocalName
        self.saveSessionCookies = saveSessionCookies
        self.saveServerDate = saveServerDate
    }
    
    public mutating func setHeaders(headers: [String: String]) {
        self.headers = headers
    }
    
    public mutating func setParams(params: Any?) {
        self.params = params
    }
}
