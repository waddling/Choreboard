//
//  User.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/29/21.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var _id: String = ""
    @objc dynamic var _partition: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var name: String? = nil
    @objc dynamic var pictureURL: String?
    let memberOf = RealmSwift.List<String>()
    @objc dynamic var firstTimeSetup: Bool = true
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

struct UserSwift {
    let id: String
    let firstName: String
    let middleName: String?
    let lastName: String
    let nickname: String?
    let householdName: String?
    let householdId: String?
}
