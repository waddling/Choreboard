//
//  Chore.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/29/21.
//

import Foundation

struct Chore {
    let title: String
    let description: String
    let createdBy: User
    let assignedTo: User
    let creationDate: Date
    let dueDate: Date
    let repeating: Bool
    let points: Int
    let completed: Bool
}
