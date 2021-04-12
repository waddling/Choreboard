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
    @objc dynamic var name: String?
    @objc dynamic var partition: String?
    convenience init(partition: String, name: String) {
        self.init()
        self.partition = partition
        self.name = name
    }
}
