//
//  Chore.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/29/21.
//

import Foundation
import RealmSwift

enum ChoreStatus: String {
    case Open
    case InProgress
    case Complete
}

class Chore: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var details: String?
    @objc dynamic var createdBy: User? = User()
    @objc dynamic var assignedTo: User? = User()
    @objc dynamic var creationDate: Date = Date()
    @objc dynamic var dueDate: Date?
    @objc dynamic var repeating: Bool = false
    @objc dynamic var points: Int = 0
    @objc dynamic var status: String = ""
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    var statusEnum: ChoreStatus {
        get {
            return ChoreStatus(rawValue: status) ?? .Open
        }
        set {
            status = newValue.rawValue
        }
    }
    
    convenience init(partition: String, title: String, createdBy: User, assignedTo: User, dueDate: Date, repeating: Bool, points: Int, status: String) {
        self.init()
        self._partition = partition
        self.title = title
        self.createdBy = createdBy
        self.assignedTo = assignedTo
        self.creationDate = Date()
        self.dueDate = dueDate
        self.repeating = repeating
        self.points = points
        self.status = status
    }
}

struct ChoreSwift {
    let title: String
    let details: String
    let createdBy: User
    let assignedTo: User
    let creationDate: Date
    let dueDate: Date
    let repeating: Bool
    let points: Int
    let completed: Bool
}
