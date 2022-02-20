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
                nameClass = String(
                    format: "%@.%@",
                    arguments: [
                        "ghurlsessioncore",
                        "GHURLSessionCoreManager"
                    ]
                )
            case .URLRxSession:
                nameClass = String(
                    format: "%@.%@",
                    arguments: [
                        "ghurlsessioncombine",
                        "GHURLSessionRxCoreManager"
                    ]
                )
            case .Alamo:
                nameClass = String(
                    format: "%@.%@",
                    arguments: [
                        "ghalamocore",
                        "GHAlamoCoreManager"
                    ]
                )
        }
        
        return nameClass
    }
}
