//
//  NoteViewModel.swift
//  Numbi
//
//  Created by Vadym on 24.04.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import Foundation
//import RxSwift
//import RxCocoa
import RealmSwift
//import RxRealm
import MathParser

protocol NoteViewModelProtocol {
}

class NoteViewModel: NoteViewModelProtocol {
    let realm = try! Realm()
    
    let defaults = UserDefaults.standard
    static var lastNote: Int = 0
    
    let title = "Numbi"
    let userDefaultsKey = "LastRow"
    
    func getResult(input: String?) -> String {
        var input = input!.split(separator: "\n", omittingEmptySubsequences: false)
        let result = input.transformOmittingEmptySubsequences("\n").map { String($0).math() }.joined(separator: "\n")
        
        return result
    }
    
    // MARK: Realm
    func appStart(at row: Int) {
        guard self.realm.objects(NoteData.self).count < 1 else { return }
        let newItem = NoteData()
        newItem.noteText = ""
        newItem.dateCreated = Date()
        do {
            try realm.write {
                realm.add(newItem)
            }
        } catch {
            print("Error saving context, \(error)")
        }
    }
}

extension String {
    func math() -> String {
        let expr = Parser.parse(string: self)
        guard let exprValue = expr?.evaluate() else { return "" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        //formatter.locale = .current
        //formatter.usesSignificantDigits = false
        //formatter.maximumSignificantDigits = 9 // default
        formatter.maximumFractionDigits = 3
        formatter.maximumIntegerDigits = 9
        
        let result = NSDecimalNumber(decimal: exprValue).doubleValue
        
        if String(result).count > 10 {
            return String(format: "%.4e", result)
        } else {
            return formatter.string(from: NSNumber(value: result))!
        }
    }
}

extension Array where Element == Substring {
    mutating func transformOmittingEmptySubsequences (_ character: Substring) -> [Substring] {
        for i in 0..<self.count {
            if self[i] == "" {
                self[i] = character
            }
        }
        return self
    }
}
