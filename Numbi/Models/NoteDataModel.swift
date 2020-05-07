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
    @objc dynamic var noteText: String?
    @objc dynamic var dateCreated: Date?
}
