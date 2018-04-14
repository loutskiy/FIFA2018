//
//  Migration.swift
//
//  Copyright © 2018 BigBadBird. All rights reserved.
//

import Foundation
import RealmSwift

struct DATABASE_INFO {
    private struct INFO {
        static let version = 3
    }
    static var Ver: UInt64 {
        return UInt64(INFO.version)
    }
}

class Migration {
    static func applyMigration () {
        let config = Realm.Configuration(
            schemaVersion: DATABASE_INFO.Ver,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < DATABASE_INFO.Ver) {
                }
        })
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
}
