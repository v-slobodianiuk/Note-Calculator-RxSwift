//
//  ListViewModel.swift
//  Numbi
//
//  Created by Vadym on 12.05.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import Foundation
import RealmSwift

protocol ListViewModelProtocol {
}

class ListViewModel: ListViewModelProtocol {
    
    let realm = try! Realm()
    var data: Results<NoteData>!
    let cell = "ListCell"
    let title = "All Notes"
    
    func getDataCell() {
        data = realm.objects(NoteData.self)
    }
}
