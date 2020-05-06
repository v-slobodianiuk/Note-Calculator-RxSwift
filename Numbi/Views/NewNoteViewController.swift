//
//  NewNoteViewController.swift
//  Numbi
//
//  Created by Vadym on 04.05.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MathParser

class NewNoteViewController: UIViewController {
    
    private let noteView = NewNoteView()
    private let throttleIntervalInMilliseconds = 10
    private let disposeBag = DisposeBag()
    
    var textViewIndex = 0
    var tempResult = ""
    
    override func loadView() {
        self.view = noteView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        left()
    }
    
    func left() {
        noteView.leftTextView.rx.text
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(self.throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                //let rows = self.lineCounter(self.noteView.leftTextView)
                //print(rows)
                
                
                
                guard let ch = $0?.last else { return }
                
                if ch == "\n" {
                    let result = self.splitPlusSeparator($0!, separator: "\n")
                }
                
            })
            .disposed(by: self.disposeBag)
    }

    func splitPlusSeparator(_ string: String, separator: Character) -> [String] {
        var result: Array<String> = []
        var temp: Array<Character> = []
        
        string.forEach { c in
            guard c == "!" else { return temp.append(c) }
            result.append(temp.map({String($0)}).joined(separator: ""))
            result.append("\(c)")
            temp = []
        }
        result.append(temp.map({String($0)}).joined(separator: ""))
        
        return result
    }
    
    func lineCounter(_ textView: UITextView) -> Int {
        let layoutManager:NSLayoutManager = textView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        print(numberOfGlyphs)
        var numberOfLines = 0
        var index = 0
        var lineRange:NSRange = NSRange()
        
        while (index < numberOfGlyphs) {
            print(layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange))
            index = NSMaxRange(lineRange);
            numberOfLines = numberOfLines + 1
        }
        return numberOfLines
    }
    
}

//class CalcTextView: UITextView {
//
//    override func deleteBackward() {
//        super.deleteBackward()
//
//    }
//}
