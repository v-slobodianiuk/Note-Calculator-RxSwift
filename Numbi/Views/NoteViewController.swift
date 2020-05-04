//
//  TestViewController.swift
//  Numbi
//
//  Created by Vadym on 23.04.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MathParser

class NoteViewController: UIViewController {
    
    //var menu: ListViewController?
    var isMove = false
    
    private let noteView = NoteView()
    private let noteViewModel = NoteViewModel()
    private let throttleIntervalInMilliseconds = 500
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = noteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = noteViewModel.NoteNavTitle
        if #available(iOS 13, *) {
            let leftButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(listPressed))
            let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
            self.navigationItem.leftBarButtonItem = leftButton
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        
        noteView.tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: noteViewModel.NoteCellId)
         
        setupCellConfiguration()
        
        DispatchQueue.main.async {
            self.noteView.tableView.reloadData()
        }
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func listPressed() {
        let menuVC = ListViewController()
           self.navigationController?.pushViewController(menuVC, animated: true)
    }
    
    func setupCellConfiguration() {
        NoteViewModel.rxData
            .bind(to: noteView.tableView
                .rx
                .items(cellIdentifier: noteViewModel.NoteCellId, cellType: NoteTableViewCell.self)) { row, element, cell in
                    DispatchQueue.main.async {
                        cell.getText(text: element)
                        
                        cell.textView
                            .rx
                            .text
                            .observeOn(MainScheduler.asyncInstance)
                            .distinctUntilChanged()
                            .throttle(.milliseconds(self.throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
                            .subscribe(onNext: {
                                NoteViewModel.defaults.set(NoteViewModel.rxData.value, forKey: "Data")
                                //print(NoteViewModel.rxData.value)
                                
                                let checker = ($0 ?? "").replacingOccurrences(of: "% of ", with: "*0.01*")
                                
                                let expr = Parser.parse(string: checker)
                                let exprValue = expr?.evaluate()
                                cell.resultLabel.text = NSDecimalNumber(decimal: exprValue ?? 0).stringValue
                                
                                self.atrString(str: $0, textView: cell.textView)
                                
//                                if let textFont = cell.textView.font {
//                                    let numLines = (cell.textView.contentSize.height / textFont.lineHeight) as? Int
//                                    print(numLines)
//                                }
                                
                                let layoutManager:NSLayoutManager = cell.textView.layoutManager
                                let numberOfGlyphs = layoutManager.numberOfGlyphs
                                var numberOfLines = 0
                                var index = 0
                                var lineRange:NSRange = NSRange()

                                while (index < numberOfGlyphs) {
                                    layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
                                    index = NSMaxRange(lineRange);
                                    numberOfLines = numberOfLines + 1
                                }

                                print(numberOfLines)

                                
                                
                            })
                            .disposed(by: self.disposeBag)
                        
                        if !cell.textView.isFirstResponder {
                            UIView.performWithoutAnimation {
                                cell.textView.becomeFirstResponder()
                            }
                        }
                    }
                    
                    cell.textView.rx.didChange.subscribe(onNext: { [weak self] in
                        self?.noteView.tableView.beginUpdates()
                        self?.noteView.tableView.endUpdates()
                    })
                        .disposed(by: self.disposeBag)
        }
        .disposed(by: disposeBag)
    }
    
//    func keyboardSettings() {
//
//
//        // MARK: Change View frame y position by default when we call Keyboard
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (Notification) in
//
//            // if keyboard size is not available for some reason, dont do anything
//            guard let keyboardSize = (Notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
//
//            self.view.frame.origin.y = 0 - keyboardSize.height / 2
//        }
//
//        // MARK: Set View frame y position by default
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { _ in
//            self.view.frame.origin.y = 0
//        }
//    }
    
    func  customizeColor(string: String, color: UIColor) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: color,
        ]
        
        return NSMutableAttributedString(string: string, attributes: attributes)
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
    
    deinit {
        print("deinited")
    }
}
