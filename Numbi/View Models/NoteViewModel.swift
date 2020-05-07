//
//  NoteViewModel.swift
//  Numbi
//
//  Created by Vadym on 24.04.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class NoteViewModel {
    
    let realm = try! Realm()
    var realmArray: Results<NoteData>?
    
    let NoteNavTitle = "Numbi"
    let NoteCellId = "Note Cell"
    static var rxData: BehaviorRelay<[String]> = BehaviorRelay(value: [""])
    
    // MARK: - Realm Methods
    func sendToRealm(_ string: String) {
        realmArray = nil
        let lastImage = NoteData()
        lastImage.noteText = string
        lastImage.dateCreated = Date()
        self.save(data: lastImage)
        let test = realmArray?[0].noteText
    }
    
    func save(data: NoteData) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    func clearRealm() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Error removing items, \(error)")
        }
    }
    
    func loadHistory() {
        realmArray = realm.objects(NoteData.self)
    }
}
