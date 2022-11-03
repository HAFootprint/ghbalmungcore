//
//  GHBaseCoreManager.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation
import ghgungnircore
import Combine

open class GHBaseCoreManager: NSObject, GHCoreBalmungDelegate {
    public var delegate: GHConnectionBalmungDelegate?
    public var certificate: String?
    
    public lazy var _dcConnection: [String: URLSession]? = [:]
    
    public override required init() {
        super.init()
    }
    
    @available(iOS 13.0, *)
    open func submitRequest(bundle: Bundle, metadata: GHMetadataModel, restMethod: GHRestType, restContentType: GHRestContentType) -> AnyPublisher<Any, Error>? {
        if GHDependencyConfigManager.getIdentifierRestServer(bundle: bundle) == .simulation ||
            metadata.forceSimulationFlow {
            
            let dic = self.dictionaryWithContentsOfJSONString(
                fileLocation: metadata.jsonLocalName,
                bundleIdentifier: GHDependencyConfigManager.getIdentifierBundleJsonMock(
                    bundle: bundle
                )
            )
            
            let model = GHResponseModel(
                identifier: metadata.type,
                statusCode: 200,
                data: dic,
                responseHeaders: [:]
            )
            
            return Result.Publisher(.success(model))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        
        return nil
    }
    
    open func submitRequest(bundle: Bundle, metadata: GHMetadataModel, restMethod: GHRestType, restContentType: GHRestContentType) -> Bool {
        if GHDependencyConfigManager.getIdentifierRestServer(bundle: bundle) == .simulation ||
            metadata.forceSimulationFlow {
            
            let dic = self.dictionaryWithContentsOfJSONString(
                fileLocation: metadata.jsonLocalName,
                bundleIdentifier: GHDependencyConfigManager.getIdentifierBundleJsonMock(
                    bundle: bundle
                )
            )
            
            self.delegate?.receiveData(
                identifier: metadata.type,
                code: 200,
                data: dic,
                responseHeaders: [:]
            )
            
            return false
        }
        
        return true
    }
    
    public func convertToDictionary(data: Any?) -> [String: Any]? {
        if let data = data as? Data {
            do {
                return try JSONSerialization.jsonObject(
                    with: data,
                    options: []
                ) as? [String: Any]
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    public func getGenericObject<T>(restMethod: GHRestType, responseData: Data) -> T? {
        var gen: T?
        
        do {
            let str = String(decoding: responseData, as: UTF8.self)
            print("GIPSY DANGER RESPONSE DATA: \(str)")
            
            if restMethod == .GET_XML {
                gen = str as? T
            }
            else {
                if str.isEmpty {
                    gen = [:] as? T
                }
                else if let generic = try JSONSerialization.jsonObject(with: responseData, options: []) as? T {
                    gen = generic
                }
            }
        }
        catch {
            gen = [GHBalmungContants.genericKeyServiceResponse: responseData] as? T
        }
        
        return gen
    }
    
    public func interceptRequest(
        bundle: Bundle,
        metadata: GHMetadataModel,
        restMethod: GHRestType,
        contentType: GHRestContentType,
        url: URL
    ) -> URLRequest {
        var request = URLRequest(url: url)
        var headers: [String: String] = restMethod.contentType(contentType: contentType)
        
        request.httpMethod          = restMethod.rawString
        request.timeoutInterval     = metadata.forceTimeOutFlow ?? GHDependencyConfigManager.timeOutInterval(
            bundle: bundle
        )
        
        if restMethod.hasBody {
            if restMethod == .POST_FORM_DATA {
                if let data = metadata.params as? Data {
                    do {
                        if let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any?] {
                            let boundary = "Boundary-\(UUID().uuidString)"
                            let body = GHBalmungTools.createBody(parameters: dic, boundary: boundary)
                            request.httpBody = body
                            
                            headers = restMethod.contentType(contentType: contentType, boundary: boundary, length: body.count)
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            }
            else if restMethod == .POST_FILE_FORM_DATA {
                if let data = metadata.params as? Data {
                    do {
                        if let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any?] {
                            let boundary = "Boundary-\(UUID().uuidString)"
                            let body = GHBalmungTools.createFileBody(parameters: dic, boundary: boundary)
                            request.httpBody = body
                            
                            headers = restMethod.contentType(contentType: contentType, boundary: boundary, length: body.count)
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            }
            else if restMethod == .POST_URL_ENC {
                if let data = metadata.params as? Data {
                    do {
                        if let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?] {
                            let parameterArray = dic.map { (key, value) -> String in
                                guard let value = value else { return .empty }
                                
                                return "\(key)=\(value)"
                                //TODO: Revisar encoding
                                //"\(key)=\(self.percentEscapeString(any: value))"
                            }.filter { $0.isNotEmpty }
                            
                            request.httpBody = parameterArray.joined(separator: "&").data(using: .utf8)
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            }
            else {
                request.httpBody = metadata.params as? Data
            }
        }
        
        if let dic = metadata.headers, headers.isNotEmpty {
            dic.forEach { headers[$0.key] = $0.value }
        }
        
        request.allHTTPHeaderFields = headers

        if metadata.saveSessionCookies {
            if let data = UserDefaults.standard.object(forKey: "gh_cookies") as? Data,
               let cookies = NSKeyedUnarchiver.unarchiveObject(with: data) as? [GHCookieModel], cookies.isEmpty {

                cookies.forEach { bmpCookie in
                    if let newCookie = HTTPCookie(
                            properties: [
                                .name: bmpCookie.Name,
                                .value: bmpCookie.Value,
                                .path: bmpCookie.Path,
                                .domain: bmpCookie.Domain
                            ]
                    ) {
                        HTTPCookieStorage.shared.setCookie(newCookie)
                    }
                }
            }
        }

        return request
    }
    
    public func interceptResponse(
        response: URLResponse?,
        metadata: GHMetadataModel
    ) -> (statusCode: Int, responseHeaders: [AnyHashable : Any]) {
        if let httpResponse = response as? HTTPURLResponse {
            print("GIPSY DANGER STATUS: \(httpResponse.statusCode)")

            if metadata.saveSessionCookies {
                if let arrCookies = HTTPCookieStorage.shared.cookies {
                    var cookies: [GHCookieModel] = []
                    for cookie in arrCookies {
                        let cookieModel = GHCookieModel(
                            name: cookie.name,
                            value: cookie.value,
                            path: cookie.path,
                            domain: cookie.domain
                        )
                        
                        print("GIPSY DANGER COOKIE: \(cookieModel)")
                        cookies.append(cookieModel)
                    }

                    let saveData = NSKeyedArchiver.archivedData(withRootObject: cookies)
                    UserDefaults.standard.set(saveData, forKey: "gh_cookies")
                }
            }

            if metadata.saveServerDate {
                if let dateServer = httpResponse.allHeaderFields["Date"] as? String {
                    GHStatusStorage.dateServerStr = dateServer
                    GHStatusStorage.dateDevice = Date()
                }
            }

            print("GIPSY DANGER RESPONSE: \(httpResponse)")
            
            return (httpResponse.statusCode, httpResponse.allHeaderFields)
        }
        
        return (-1, [:])
    }
    
    open func cancelAllRequest() {
        
    }
    
    open func removeReferenceContext() {
        self.cancelAllRequest()
        
        self.certificate = nil
        self.delegate = nil
    }
}
