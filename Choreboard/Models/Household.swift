//
//  Household.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/29/21.
//

import Foundation
import RealmSwift

class Household: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition: String = ""
    @objc dynamic var name = ""
    let members = List<User>()
    let chores = List<Chore>()
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
