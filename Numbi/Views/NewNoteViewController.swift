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
    private let throttleIntervalInMilliseconds = 500
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = noteView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Numbi"
        
        noteView.leftTextView.becomeFirstResponder()
        
        setupInputView()
    }
    
    func setupInputView() {
        noteView.leftTextView.rx.text
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(self.throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                
                var input = $0!.split(separator: "\n", omittingEmptySubsequences: false)
                let result = input.transformOmittingEmptySubsequences("\n").map { String($0).math() }.joined(separator: "\n")
                
                self.noteView.rightTextView.text = result //String(format: "%.2f", result)
                
                //self.atrString(str: result, textView: self.noteView.leftTextView)
            })
            .disposed(by: self.disposeBag)
    }
    
        func atrString(str: String?, textView: UITextView) {
            let aString = self.customizeColor(string: "\(str ?? "")", color: UIColor.black)
            
    //        let chArray: Set<Character> = ["+", "-", "*", "/", "%"]
    //
    //        for c in chArray {
    //            if (str?.contains("\(c)"))! {
    //
    //                let r1 = str!.range(of: "\(c)")!
    //                let atr = self.customizeColor(string: "\(c)", color: UIColor.systemOrange)
    //                aString.replaceCharacters(in: NSRange(r1, in: str!), with: atr)
    //                }
    //        }
            
            
            if (str?.contains("+"))! {
                
                let r1 = str!.range(of: "+")!
                let atr = self.customizeColor(string: "+", color: UIColor.systemOrange)
                aString.replaceCharacters(in: NSRange(r1, in: str!), with: atr)
            }
            if (str?.contains("-"))! {
                
                let r1 = str!.range(of: "-")!
                let atr = self.customizeColor(string: "-", color: UIColor.systemOrange)
                aString.replaceCharacters(in: NSRange(r1, in: str!), with: atr)
            }
            if (str?.contains("*"))! {
                
                let r1 = str!.range(of: "*")!
                let atr = self.customizeColor(string: "*", color: UIColor.systemOrange)
                aString.replaceCharacters(in: NSRange(r1, in: str!), with: atr)
            }
            if (str?.contains("/"))! {
                
                let r1 = str!.range(of: "/")!
                let atr = self.customizeColor(string: "/", color: UIColor.systemOrange)
                aString.replaceCharacters(in: NSRange(r1, in: str!), with: atr)
            }
            if (str?.contains("%"))! {
                
                let r1 = str!.range(of: "%")!
                let atr = self.customizeColor(string: "%", color: UIColor.systemOrange)
                aString.replaceCharacters(in: NSRange(r1, in: str!), with: atr)
            }
            
            if (str?.contains("of"))! {
                
                let r1 = str!.range(of: "of")!
                let atr = self.customizeColor(string: "of", color: UIColor.systemPurple)
                aString.replaceCharacters(in: NSRange(r1, in: str!), with: atr)
            }
            
            //l1AttrString.append(self.customizeColor(string: "!", color: UIColor.red))
            textView.attributedText = aString
    }
    
    func  customizeColor(string: String, color: UIColor) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: color,
        ]
        
        return NSMutableAttributedString(string: string, attributes: attributes)
    }
}

extension String {
    func math() -> String {
        let expr = Parser.parse(string: self)
        guard let exprValue = expr?.evaluate() else { return "" }
        return NSDecimalNumber(decimal: exprValue).stringValue
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
