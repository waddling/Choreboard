//
//  Member.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 5/2/21.
//

import Foundation
import RealmSwift

class Member: Object {
    @objc dynamic var _id: String = ObjectId.generate().stringValue
    @objc dynamic var _partition: String = ""
    @objc dynamic var name: String? = nil
    @objc dynamic var pictureURL: String? = nil
    @objc dynamic var points = 0
    @objc dynamic var userId: String? = nil
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(name: String, points: Int, pictureURL: String) {
        self.init()
        self.name = name
        self.points = points
        self.pictureURL = pictureURL
    }
    
    convenience init(user: User, household: Household) {
        self.init()
        self._partition = household._partition
        self.name = user.name
        self.pictureURL = user.pictureURL
        self.userId = user._id
    }
}

