//
//  ClusterModel.swift
//  FIFA2018
//
//  Created by Mikhail Lutskiy on 15.04.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class ClusterModel : Object, Mappable {
    @objc dynamic var Latitude = 0.0
    @objc dynamic var Longitude = 0.0
    @objc dynamic var Alpha = 0.0
    @objc dynamic var Count = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        Latitude <- map["Latitude"]
        Longitude <- map["Longitude"]
        Alpha <- map["Alpha"]
        Count <- map["Count"]
    }
}
