//
//  File.swift
//  
//
//  Created by Javier Carapia on 26/10/22.
//

import Foundation

public class GHMetadataModelBuilder {
    private lazy var metadataModel = GHMetadataModel()
    
    public init() { }
    
    public func setUrl(url: String) -> GHMetadataModelBuilder {
        self.metadataModel.url = url
        return self
    }
    
    public func setLocalJsonName(name: String) -> GHMetadataModelBuilder {
        self.metadataModel.jsonLocalName = name
        return self
    }
    
    public func setSaveSessionCookies(saveCookies: Bool) -> GHMetadataModelBuilder {
        self.metadataModel.saveSessionCookies = saveCookies
        return self
    }
    
    public func setSaveServerDate(saveDate: Bool) -> GHMetadataModelBuilder {
        self.metadataModel.saveServerDate = saveDate
        return self
    }
    
    public func setCertificateAuthority(cert: String) -> GHMetadataModelBuilder {
        self.metadataModel.certificateAuthority = cert
        return self
    }
    
    public func setBody(body: Any?) -> GHMetadataModelBuilder {
        self.metadataModel.params = body
        return self
    }
    
    public func setHeaders(headers: [String: String]?) -> GHMetadataModelBuilder {
        self.metadataModel.headers = headers
        return self
    }
    
    public func setType(type: Any) -> GHMetadataModelBuilder {
        self.metadataModel.type = type
        return self
    }
    
    public func setForceSimulationByFlow(forceSimulation: Bool) -> GHMetadataModelBuilder {
        self.metadataModel.forceSimulationFlow = forceSimulation
        return self
    }
    
    public func setRetryCounter(retry: Int) -> GHMetadataModelBuilder {
        self.metadataModel.retryCounter = retry
        return self
    }
    
    public func setForceInvalidateAndCancel(force: Bool) -> GHMetadataModelBuilder {
        self.metadataModel.forceInvalidateAndCancel = force
        return self
    }
    
    public func setforceTimeOutFlow(timeOut: TimeInterval) -> GHMetadataModelBuilder {
        self.metadataModel.forceTimeOutFlow = timeOut
        return self
    }
    
    public func build() -> GHMetadataModel {
        return self.metadataModel
    }
}

