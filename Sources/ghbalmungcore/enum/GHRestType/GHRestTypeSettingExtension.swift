//
//  GHRestTypeSettingExtension.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

extension GHRestType {
    public var rawString: String {
        switch self {
            case .GET, .GET_XML:
                return "GET"
            case .POST, .POST_URL_ENC, .POST_FORM_DATA, .POST_FILE_FORM_DATA:
                return "POST"
            case .PUT:
                return "PUT"
            case .DELETE:
                return "DELETE"
            case .PATCH:
                return "PATCH"
        }
    }
    
    internal var hasBody: Bool {
        let met = self.rawString
        return met == "POST" || met == "PATCH" || met == "PUT" || met == "DELETE"
    }
    
    public var contentType: [String: String] {
        switch self {
        case .POST_FORM_DATA(let boundary, let len), .POST_FILE_FORM_DATA(let boundary, let len):
            return [
                "Content-Type": "multipart/form-data; boundary=\(boundary)",
                "Content-Length": "\(len)"
            ]
        case .POST_URL_ENC:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
