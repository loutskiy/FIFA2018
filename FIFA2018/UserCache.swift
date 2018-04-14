//
//  UserCache.swift
//  FIFA2018
//
//  Created by Mikhail Lutskiy on 14.04.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
class UserCache: NSObject {
    
    /// Func for get login status
    ///
    /// - Returns: isLogin
    static func isLogin () -> Bool {
        return UserDefaults.standard.bool(forKey: "isLogin")
    }
    
    static func countryId () -> Int {
        return UserDefaults.standard.integer(forKey: "country_id")
    }
    
    static func date () -> Date {
        return UserDefaults.standard.object(forKey: "date") as! Date
    }
    
    static func uuid () -> String {
        return UserDefaults.standard.string(forKey: "uuid")!
    }
    
    /// Func for change login state
    ///
    /// - Parameter loginState: isLogin
    static func changeLoginState (_ loginState: Bool) {
        UserDefaults.standard.set(loginState, forKey: "isLogin")
    }
    
    static func setCountryId (_ userId: Int) {
        UserDefaults.standard.set(userId, forKey: "country_id")
    }
    
    static func setDate (_ date: Date) {
        UserDefaults.standard.set(date, forKey: "date")
    }
    
    static func setUUID (_ uuid: String) {
        UserDefaults.standard.set(uuid, forKey: "uuid")
    }
}
