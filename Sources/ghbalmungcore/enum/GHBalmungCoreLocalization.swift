//
//  GHBalmungCoreLocalization.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation
import ghgungnircore

public enum GHBalmungCoreLocalization: String {
    case defaultError
    case notReceiveData
    case invalidUrl
    case connectionNotDetected
    
    public func localize(bundle: Bundle) -> String {
        self.localizedString(
            key: self,
            bundle: bundle
        )
    }
    
    public func errorLocalize(bundle: Bundle) -> Error {
        return GHError.make(
            message: self.localize
        )
    }

    private func localizedString(key: GHBalmungCoreLocalization, bundle: Bundle) -> String {
        NSLocalizedString(
            key.rawValue,
            tableName: "ghbalmungcore",
            bundle: self.bundleForResource(
                bundle: bundle
            ),
            comment: key.rawValue
        )
    }

    private func bundleForResource(bundle: Bundle) -> Bundle {
        //TODO: Revisar el crear un Bundle por tipo de implementación
        guard let path = bundle.path(forResource: "ghbalmungcoreresources", ofType: "bundle") else {
            return bundle
        }

        guard let bundlePath = Bundle(path: path) else {
            return bundle
        }

        return bundlePath
    }
}
