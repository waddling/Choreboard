//
//  SettingsModels.swift
//  Choreboard
//
//  Created by Joseph Delle Donne on 4/13/21.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
