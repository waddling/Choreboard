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
    @objc dynamic var profilePictureLink: String? = nil
    @objc dynamic var userId: String? = nil
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(user: User, household: Household) {
        self.init()
        self._partition = household._partition
        self.name = user.name
        self.profilePictureLink = user.profilePictureLink
        self.userId = user._id
    }
}

