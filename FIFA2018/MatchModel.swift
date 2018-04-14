//
//  MatchModel.swift
//  FIFA2018
//
//  Created by Mikhail Lutskiy on 15.04.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class MatchModel : Object, Mappable {
    @objc dynamic var ID = 0
    @objc dynamic var Name = ""
    @objc dynamic var Path = ""
    @objc dynamic var Stadion: Stadion?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "ID"
    }
    
    func mapping(map: Map) {
        ID <- map["ID"]
        Name <- map["Name"]
        Path <- map["Path"]
        Stadion <- map["Stadion"]
    }
}

class Stadion: Object, Mappable {
    @objc dynamic var ID = 0
    @objc dynamic var Name = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "ID"
    }
    
    func mapping(map: Map) {
        ID <- map["ID"]
        Name <- map["Name"]
    }
}
