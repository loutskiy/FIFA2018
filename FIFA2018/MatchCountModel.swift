//
//  MatchCountModel.swift
//  FIFA2018
//
//  Created by Mikhail Lutskiy on 15.04.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class MatchCountModel : Object, Mappable {
    @objc dynamic var CountryID1 = 0
    @objc dynamic var Count1 = 0
    @objc dynamic var CountryID2 = 0
    @objc dynamic var Count2 = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        CountryID1 <- map["CountryID1"]
        Count1 <- map["Count1"]
        CountryID2 <- map["CountryID2"]
        Count2 <- map["Count2"]
    }
}
