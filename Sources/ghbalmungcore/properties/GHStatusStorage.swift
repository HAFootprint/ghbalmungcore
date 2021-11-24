//
//  GHStatusStorage.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

import Foundation

public struct GHStatusStorage {
    private static let dateServerStrKey         = "gh_date_device_str_key"
    private static let dateDeviceKey            = "gh_date_device_key"
    private static let globalDateServerFormat   = "EEE, dd MMM yyyy HH:mm:ss z"

    public static var dateServerStr: String {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: self.dateServerStrKey)
        }
        get {
            let defaults = UserDefaults.standard
            return defaults.object(forKey: self.dateServerStrKey) as? String ?? .empty
        }
    }

    public static var dateDevice: Date? {
        set {
            if let date = newValue {
                let defaults = UserDefaults.standard
                defaults.set(date, forKey: self.dateDeviceKey)
            }
        }
        get {
            let defaults = UserDefaults.standard
            return defaults.object(forKey: self.dateDeviceKey) as? Date
        }
    }

    public static var dateServer: Date? {
        let dateStr = dateServerStr
        if dateStr.isNotEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = self.globalDateServerFormat
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")

            let date = dateFormatter.date(from: dateStr)
            return date
        }

        return nil
    }

    public static func deleteAllDataStorage() {
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: self.dateServerStrKey)
        prefs.removeObject(forKey: self.dateDeviceKey)
    }
}
