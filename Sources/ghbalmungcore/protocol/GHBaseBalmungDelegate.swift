//
//  GHBaseBalmungDelegate.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation

public protocol GHBaseBalmungDelegate {
    func requestFailWithError(identifier: Any, code: Int, data: NSDictionary, error: Error)
}
