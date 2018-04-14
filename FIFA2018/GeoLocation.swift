//
//  GeoLocation.swift
//  Zachetka
//
//  Created by Mikhail Lutskiy on 14.03.2018.
//  Copyright © 2018 BigBadBird. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class GeoLocation: Object, Mappable {
    @objc dynamic var Latitude = 0.0
    @objc dynamic var Longitude = 0.0
    @objc dynamic var SectorName = ""
    @objc dynamic var SectorNumber = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        Latitude <- map["Latitude"]
        Longitude <- map["Longitude"]
        SectorName <- map["SectorName"]
        SectorNumber <- map["SectorNumber"]
    }
}
