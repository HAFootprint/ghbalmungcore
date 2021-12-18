//
//  GHBaseCoreManager.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation
import ghgungnircore
import Combine

internal class GHBaseCoreManager: NSObject, GHCoreBalmungDelegate {
    internal var delegate: GHConnectionBalmungDelegate?
    internal var certificate: String?
    
    override required init() {
        super.init()
    }
    
    @available(iOS 13.0, *)
    func submitRequest(bundle: Bundle, metadata: GHMetadataModel, restMethod: GHRestType) -> AnyPublisher<Any, Error>? {
        return nil
    }
    
    internal func submitRequest(bundle: Bundle, metadata: GHMetadataModel, restMethod: GHRestType) -> Bool {
        if GHDependencyConfigManager.getIdentifierRestServer(bundle: bundle) == .simulation {
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
    
    internal func convertToDictionary(data: Any?) -> [String: Any]? {
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
    
    internal func getGenericObject<T>(restMethod: GHRestType, responseData: Data) -> T? {
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
            gen = ["gh_generic_key": responseData] as? T
        }
        
        return gen
    }
    
    internal func interceptRequest(
        bundle: Bundle,
        metadata: GHMetadataModel,
        restMethod: GHRestType,
        url: URL
    ) -> URLRequest {
        var request = URLRequest(url: url)
        
        if restMethod.hasBody {
            request.httpBody = metadata.params as? Data
        }
        
        request.httpMethod          = restMethod.rawString
        request.timeoutInterval     = GHDependencyConfigManager.timeOutInterval(
            bundle: bundle
        )
        
        var headers = restMethod.contentType
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
    
    internal func interceptResponse(
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
                        
                        dump("GIPSY DANGER COOKIE: \(cookieModel)")
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
    
    internal func cancelAllRequest() {
        
    }
    
    func removeReferenceContext() {
        self.cancelAllRequest()
        
        self.certificate = nil
        self.delegate = nil
    }
}
