//
//  NoteDataModel.swift
//  Numbi
//
//  Created by Vadym on 24.04.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import Foundation
import RealmSwift

class NoteData: Object {
    @objc dynamic var id = 0
    @objc dynamic var noteText: String = "Hello World"
    @objc dynamic var dateCreated: Date?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
