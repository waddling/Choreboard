//
//  Household.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/29/21.
//

import Foundation
import RealmSwift

class Household: Object {
    @objc dynamic var _id: String = ObjectId.generate().stringValue
    @objc dynamic var _partition: String = ""
    @objc dynamic var name: String? = nil
    let members = RealmSwift.List<Member>()
    let chores = RealmSwift.List<Chore>()
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
