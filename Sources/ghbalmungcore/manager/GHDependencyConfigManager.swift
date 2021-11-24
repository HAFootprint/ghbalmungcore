//
//  GHDependencyConfigManager.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 22/11/21.
//

import Foundation
import ghgungnircore

public struct GHDependencyConfigManager {
    private static let ghConfigJsonName = "GHGlobalServiceConfig-info"
    
    //MARK: Public
    public static var getStatusNetwork: Bool {
        var connection = false
        
        do {
            let networkReachability = try Reachability()
            
            switch networkReachability.connection {
            case .unavailable:
                break
            case .wifi, .cellular:
                connection = true
                break
            }
        }
        catch { }
        
        return connection
    }
    
    public static func getStringForDictionary(dictionary: [String: Any?], first: String = "?", join: String = "&") -> String {
        var resultString: String = .empty

        for (key, value) in dictionary {
            if let val = value {
                let pivotResult = resultString.isEmpty ? first : join

                if let item = val as? String, item.isNotEmpty {
                    let valStr = item.urlEncoded() ?? item
                    resultString = resultString.appendingFormat("%@%@=%@", pivotResult, key, valStr)
                }
                else {
                    resultString = resultString.appendingFormat("%@%@=\(val)", pivotResult, key)
                }
            }
        }

        return resultString
    }
    
    public static func stringToSendService(str: String) -> String {
        var returnValue: String = .empty
        
        for char in str {
            if char == " " {
                returnValue = returnValue + "%20"
            }
            else {
                returnValue = returnValue + String(char)
            }
        }
        
        return returnValue
    }
    
    public static func getIdentifierRestServer(bundle: Bundle) -> GHEnvironmentType {
        var sourceIdentifier: GHEnvironmentType = .production

        if let entity = self.getObjectFromConfigFile(bundle: bundle),
                let identifierServer = entity.identifierServerList {
            
            if let id = identifierServer.filter({ $0.active ?? false }).first,
               let environment = id.environment, environment.isNotEmpty {
                if let identifier = GHEnvironmentType(rawValue: environment) {
                    sourceIdentifier = identifier
                }
            }
        }
        
        return sourceIdentifier
    }
    
    public static func timeOutInterval(bundle: Bundle) -> TimeInterval {
        var timeInterval = 60

        if let entity = self.getObjectFromConfigFile(bundle: bundle) {
            timeInterval = entity.timeOutInterval ?? 60
        }

        return TimeInterval(timeInterval)
    }

    //MARK: Internal
    internal static func getIdentifierBundleJsonMock(bundle: Bundle) -> String {
        var identifierJsonMock: String = .empty

        if let entity = self.getObjectFromConfigFile(
            bundle: bundle
        ) {
            identifierJsonMock = entity.bundleIdentifierJsonMock ?? .empty
        }

        return identifierJsonMock
    }

    internal static func getObjectFromConfigFile(bundle: Bundle) -> GHGlobalConfigEntity? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: self.objectFromConfigJsonKey(
                    bundle: bundle
                ),
                options: []
            ) {
                let decoded = try decoder.decode(GHGlobalConfigEntity.self, from: theJSONData)
                return decoded
            }
        }
        catch { }

        return nil
    }
    
    //MARK: Private
    private static func objectFromConfigJsonKey(bundle: Bundle) -> NSDictionary {
        var jsonOptional: NSDictionary?
        var filePath: String?

        if let path = bundle.path(forResource: self.ghConfigJsonName, ofType: "json") {
            filePath = path
        }

        if let file = filePath {
            do {
                if let data = NSData(contentsOfFile: file) {
                    jsonOptional = try JSONSerialization.jsonObject(
                        with: data as Data,
                        options: JSONSerialization.ReadingOptions.mutableContainers
                    ) as? NSDictionary
                }
            }
            catch { }
        }

        return jsonOptional ?? NSDictionary()
    }
}
