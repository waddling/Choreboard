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
    @objc dynamic var points: Int = 0
    @objc dynamic var pictureURL: String = ""
    let households = LinkingObjects(fromType: Household.self, property: "members")
    @objc dynamic var firstTimeSetup: Bool = true
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(name: String, points: Int, pictureURL: String) {
        self.init()
        self.name = name
        self.points = points
        self.pictureURL = pictureURL
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
