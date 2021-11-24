//
//  GHBalmungBaseOperationExtension.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation
import ghgungnircore

extension GHBalmungBase {
    //TEXT
    func createBody(parameters: [String : Any?], boundary: String) -> Data {
        let body = NSMutableData()
        parameters.forEach {
            body.appendString(
                self.convertFormField(
                    named: $0.key,
                    value: $0.value,
                    using: boundary
                )
            )
        }
        
        body.appendString("--\(boundary)--")
        
        return body as Data
    }
    
    private func convertFormField(named name: String, value: Any?, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        fieldString.append("\r\n")
        fieldString.append("\(value ?? String.empty)")
        fieldString.append("\r\n")

        return fieldString
    }
    
    //FILE
    func createFileBody(parameters: [String : Any?], boundary: String) -> Data {
        let body = NSMutableData()
        parameters.forEach {
            body.append(
                self.convertFileFormField(
                    named: $0.key,
                    value: $0.value,
                    using: boundary
                )
            )
        }
        
        body.appendString("--\(boundary)--")
        
        return body as Data
    }
    
    private func convertFileFormField(named name: String, value: Any?, using boundary: String) -> Data {
        let body = NSMutableData()
        
        body.appendString("--\(boundary)\r\n")
        
        body.appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(name)\(Date().timeIntervalSince1970).png\"\r\n")
        body.appendString("Content-Type: image/png\r\n")
        body.appendString("\r\n")
        
        do {
            if let urlStr = value as? String {
                let dt = try Data(contentsOf: URL(fileURLWithPath: urlStr))
                body.append(dt as Data)
            }
        }
        catch {
            print("Unable to load data: \(error)")
        }
        
        body.appendString("\r\n")

        return body as Data
    }
    
    func percentEscapeString(any: Any?) -> String {
        guard let any = any else {
            return .empty
        }
        
        if let innerStr = any as? String {
            let characterSet = NSCharacterSet.alphanumerics as! NSMutableCharacterSet
            characterSet.addCharacters(in: "-._* ")
            
            return innerStr
                .addingPercentEncoding(
                    withAllowedCharacters: characterSet as CharacterSet
                )?
                .replacingOccurrences(
                    of: " ",
                    with: "+",
                    options: [],
                    range: nil
                ) ?? innerStr
        }
        
        return "\(any)"
    }
}
