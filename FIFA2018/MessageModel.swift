//
//  MessageModel.swift
//  FIFA2018
//
//  Created by Mikhail Lutskiy on 14.04.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class MessageModel : Object, Mappable {
//    @objc dynamic var id = 0
    @objc dynamic var message = ""
    @objc dynamic var time: Date?
    @objc dynamic var uuid = ""
    @objc dynamic var countryId = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    
    func mapping(map: Map) {
//        id <- map["id"]
        message <- map["message"]
        time <- map["time"]
        uuid <- map["uuid"]
        countryId <- map["country_id"]
    }
}
