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

class NoteViewModel {
    let NoteNavTitle = "Numbi"
    let NoteCellId = "Note Cell"
    //var rxData: BehaviorRelay<[String]> = BehaviorRelay(value: [""])
    static let defaults = UserDefaults.standard
    static var rxData: BehaviorRelay<[String]> = BehaviorRelay(value: [""])
    
    func previousCell(textView: UITextView) {
        guard NoteViewModel.rxData.value.count > 1 else { return }
        guard textView.text == "" else { return }
        var update = NoteViewModel.rxData.value
        update.removeLast()
        NoteViewModel.rxData.accept(update)
    }
    
//    func setupCell(_ textView: UITextView) {
//        if NoteViewModel.rxData.value.first == "" {
//            NoteViewModel.rxData.accept(["\(textView.text ?? "")"] + [""])
//        } else {
//            var update = NoteViewModel.rxData.value
//            update[NoteViewModel.rxData.value.count - 1] = "\(textView.text ?? "")"
//            NoteViewModel.rxData.accept(update + [""])
//        }
//    }
    
    func setupCell(_ textView: UITextView) {        
        var update = NoteViewModel.rxData.value
        update[NoteViewModel.rxData.value.count - 1] = "\(textView.text ?? "")"
        NoteViewModel.rxData.accept(update + [""])
    }
    
    static func loadData() {
        if NoteViewModel.defaults.object(forKey: "Data") != nil {
            if let saveData = NoteViewModel.defaults.object(forKey: "Data") as? [String] {
                NoteViewModel.rxData.accept(saveData)
            }
        }
    }
}
