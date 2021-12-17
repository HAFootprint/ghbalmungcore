//
//  GHCoreBalmungDelegate.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation
import Combine

public protocol GHCoreBalmungDelegate {
    var delegate: GHConnectionBalmungDelegate? { get set }
    
    init()
    
    func submitRequest(bundle: Bundle, metadata: GHMetadataModel, restMethod: GHRestType) -> Bool
    @available(iOS 13.0, *)
    func submitRequest(bundle: Bundle, metadata: GHMetadataModel, restMethod: GHRestType) -> AnyPublisher<Any, URLSession.DataTaskPublisher.Failure>? 
    
    func cancelAllRequest()
    func removeReferenceContext()
}

extension GHCoreBalmungDelegate {
    func dictionaryWithContentsOfJSONString(
        fileLocation: String,
        bundleIdentifier: String
    ) -> NSDictionary {
        var jsonOptional: NSDictionary?
     
        let filePath = Bundle(identifier: bundleIdentifier)?.path(forResource: fileLocation, ofType: "json")
        if let file = filePath {
            do {
                if let data = NSData(contentsOfFile: file) {
                    jsonOptional = try JSONSerialization.jsonObject(
                        with: data as Data,
                        options: .mutableContainers
                    ) as? NSDictionary
                }
            }
            catch let error {
                print("Error <--> GHCoreBalmung: dictionaryWithContentsOfJSONString -: \(error.localizedDescription)")
            }
        }
        
        return jsonOptional ?? NSDictionary()
    }
}
