//
//  GHBalmungBaseRxExtension.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 16/12/21.
//

import Foundation
import Combine

extension GHBalmungBase {
    @available(iOS 13.0, *)
    public func doInRxVackground(metadata: GHMetadataModel, method: GHRestType) -> AnyPublisher<Any, URLSession.DataTaskPublisher.Failure>? {
        return self.coreServiceDelegate?.submitRequest(
            bundle: self.bundle,
            metadata: metadata,
            restMethod: method
        )
    }
}
