//
//  GHRestType.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation

public enum GHRestType: Equatable {
    case GET
    case GET_XML
    case POST
    case POST_URL_ENC
    case POST_FORM_DATA
    case POST_FILE_FORM_DATA
    case PUT
    case DELETE
    case PATCH
}
