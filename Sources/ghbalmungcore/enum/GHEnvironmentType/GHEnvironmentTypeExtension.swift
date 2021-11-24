//
//  GHEnvironmentTypeExtension.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation

extension GHEnvironmentType {
    public func urlList(bundle: Bundle) -> [String] {
        var url: [String] = []
        
        if let entity = GHDependencyConfigManager.getObjectFromConfigFile(bundle: bundle) {
            if let list = entity.identifierServerList?.filter({ $0.active ?? false }).first {
                url = list.urls ?? []
            }
        }
        
        return url
    }
}
