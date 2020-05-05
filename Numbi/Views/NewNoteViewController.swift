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
            let rows = self.lineCounter(self.noteView.leftTextView)
            //print(rows)
            guard let ch = $0?.last else { return }
            guard let input = self.noteView.leftTextView.text else { return }
            
            
            if ch == "\n" {
                self.tempResult.append(self.math(startIndex: self.textViewIndex, endIndex: input.count - 1, input: input))
                if rows >= 1 {
                    print(rows)
                    for _ in 0..<1 {
                        self.tempResult.append("\n")
                        print("Return added")
                    }
                }
                self.textViewIndex = input.count - 1
            } else {
                if rows <= 1 {
                   self.noteView.rightTextView.text = self.math(startIndex: self.textViewIndex, endIndex: nil, input: input)
                } else {
                    self.noteView.rightTextView.text = self.tempResult + self.math(startIndex: self.textViewIndex, endIndex: nil, input: input)
                }
            }
            
        })
            .disposed(by: self.disposeBag)
    }
    
    func result(rows: Int, closure: () -> String ) {
        if rows <= 1 {
            noteView.rightTextView.text = closure()
        } else {
            tempResult.append(closure())
            noteView.rightTextView.text = tempResult + "\n" + closure()
        }
    }
    
    
    func mathTest(textCount: Int, rows: Int, input: String) {
        self.noteView.rightTextView.text.append("return")
    }
    
    func math(startIndex: Int, endIndex: Int?, input: String) -> String {
        var temp = ""
        
        if let endIndex = endIndex {
            let start = input.index(input.startIndex, offsetBy: startIndex)
            let end = input.index(input.startIndex, offsetBy: endIndex)
            //textViewIndex = endIndex
            temp = String(input[start...end])

        } else {
            let fromIndex = input.index(input.startIndex, offsetBy: startIndex)
            //let mySubstring = input[fromIndex...]
            temp = String(input[fromIndex...])
            //print("Start Index: ", startIndex)
            //print(temp)
        }
        
        let expr = Parser.parse(string: temp)
        let exprValue = expr?.evaluate()


        if let value = exprValue {
            return NSDecimalNumber(decimal: value).stringValue
        } else {
            return ""
        }
        
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
    
    func right() {
        
    }
}

//class CalcTextView: UITextView {
//
//    override func deleteBackward() {
//        super.deleteBackward()
//
//    }
//}
