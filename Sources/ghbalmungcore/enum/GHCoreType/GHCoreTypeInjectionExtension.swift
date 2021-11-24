//
//  GNCoreTypeInjectionExtension.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

extension GHCoreType {
    func getClass() -> String {
        var nameClass: String = .empty
        
        switch self {
            case .URLSession:
                nameClass = "GHURLSessionCoreManager"
            case .Alamo:
                nameClass = "GHAlamoCoreManager"
        }
        
        return nameClass
    }
}
