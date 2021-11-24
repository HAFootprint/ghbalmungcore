//
//  GHCookieModel.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation

internal class GHCookieModel: NSCoding {
    
    //-----------All params, example: -------
    //var cookieProperties = [String: AnyObject]()
    //cookieProperties[NSHTTPCookieName] = "locale"
    //cookieProperties[NSHTTPCookieValue] = "nl_NL"
    //cookieProperties[NSHTTPCookieDomain] = "www.digitaallogboek.nl"
    //cookieProperties[NSHTTPCookiePath] = "/"
    //cookieProperties[NSHTTPCookieVersion] = NSNumber(integer: 0)
    //cookieProperties[NSHTTPCookieExpires] = NSDate().dateByAddingTimeInterval(31536000)
    //var newCookie = NSHTTPCookie(properties: cookieProperties)
    //println("\(newCookie)")
    
    private var _name: String?
    private var _value: String?
    private var _path: String?
    private var _domain: String?
    
    init() {
        _name = String()
        _value = String()
        _path = String()
        _domain = String()
    }
    
    init(name: String, value: String, path: String, domain: String) {
        _name = name
        _value = value
        _path = path
        _domain = domain
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name    = aDecoder.decodeObject(forKey: "name") as? String ?? .empty
        let value   = aDecoder.decodeObject(forKey: "value") as? String ?? .empty
        let path    = aDecoder.decodeObject(forKey: "path") as? String ?? .empty
        let domain  = aDecoder.decodeObject(forKey: "domain") as? String ?? .empty
        
        self.init(name: name, value: value, path: path, domain: domain)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_name, forKey: "name")
        aCoder.encode(_value, forKey: "value")
        aCoder.encode(_path, forKey: "path")
        aCoder.encode(_domain, forKey: "domain")
    }
    
    var Name: String {
        get {
            _name ?? .empty
        }
        set {
            _name = newValue
        }
    }
    
    var Value: String {
        get {
            _value ?? .empty
        }
        set {
            _value = newValue
        }
    }
    
    var Path: String {
        get {
            _path ?? .empty
        }
        set {
            _path = newValue
        }
    }
    
    var Domain: String {
        get {
            _domain ?? .empty
        }
        set {
            _domain = newValue
        }
    }
}
