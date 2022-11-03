//
//  File.swift
//  
//
//  Created by Javier Carapia on 19/02/22.
//

import Foundation

public enum GHErrorCore: Error {
    case coreNotFound
    case badContent
    case connectionNoDetected
    
    public var description: String {
        switch self {
            case .coreNotFound:
                return "Core Not Found. Install \(self) Core."
        case .badContent:
            return "Bad  \(self) Core."
        case .connectionNoDetected:
            return "Core Not Found. Install \(self) Core."
        }
    }
}
