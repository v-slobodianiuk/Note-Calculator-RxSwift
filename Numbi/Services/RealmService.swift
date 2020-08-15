//
//  RealmService.swift
//  Numbi
//
//  Created by Vadym on 22.05.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmServiceProtocol {
    var realm: Realm {get}
    
    func addNewNote()
    func saveData(input: String?)
    func loadData(_ textView: UITextView, row: Int)
}

class RealmService: RealmServiceProtocol {
    
    let realm = try! Realm()
    
    func last() -> Int {
        return realm.objects(NoteData.self).count - 1
    }
    
    func loadData(_ textView: UITextView, row: Int) {
        textView.text = realm.objects(NoteData.self)[row].noteText
    }
    
    func addNewNote() {
        do {
            try self.realm.write {
                let newItem = NoteData()
                newItem.noteText = ""
                newItem.dateCreated = Date()
                newItem.id = realm.objects(NoteData.self).count
                realm.add(newItem)
            }
        } catch {
            print("Error saving new items, \(error)")
        }
    }
    
    func saveData(input: String?) {
        guard let data = input else { return }
        
        //guard !currentItem.noteText.isEmpty else { return }
        do {
            try self.realm.write {
                let currentItem = NoteData()
                currentItem.noteText = data
                currentItem.dateCreated = Date()
                currentItem.id = NoteViewModel.lastNote // !!!
                self.realm.add(currentItem, update: .modified)
            }
        } catch {
            print("Error saving new items, \(error)")
        }
    }
    
    func removeData() {
        guard realm.objects(NoteData.self).count > 1 else { return }
        
        for (i, v) in realm.objects(NoteData.self).enumerated() {
            if v.noteText.isEmpty {
                do {
                    try realm.write {
                        let trash = realm.objects(NoteData.self)[i]
                        realm.delete(trash)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
        }
    }
}
