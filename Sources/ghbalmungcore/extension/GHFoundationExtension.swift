//
//  GHCharacterExtension.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation
import ghgungnircore

public extension CharacterSet {
    static let urlQueryParameterAllowed = CharacterSet.urlQueryAllowed.subtracting(
        CharacterSet(
            charactersIn: "&?"
        )
    )
    
    static let urlQueryDenied           = CharacterSet.urlQueryAllowed.inverted()
    static let urlQueryKeyValueDenied   = CharacterSet.urlQueryParameterAllowed.inverted()
    static let urlPathDenied            = CharacterSet.urlPathAllowed.inverted()
    static let urlFragmentDenied        = CharacterSet.urlFragmentAllowed.inverted()
    static let urlHostDenied            = CharacterSet.urlHostAllowed.inverted()
    
    static let urlDenied                = CharacterSet.urlQueryDenied
        .union(.urlQueryKeyValueDenied)
        .union(.urlPathDenied)
        .union(.urlFragmentDenied)
        .union(.urlHostDenied)
    
    
    func inverted() -> CharacterSet {
        var copy = self
        copy.invert()
        return copy
    }
}

public extension String {
    func urlEncoded(denying deniedCharacters: CharacterSet = .urlDenied) -> String? {
        addingPercentEncoding(withAllowedCharacters: deniedCharacters.inverted())
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        print(string)
        
        guard let data = string.data(using: .utf8, allowLossyConversion: false) else { return }
        
        append(data)
    }
}
