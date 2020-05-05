//
//  NewNoteViewController.swift
//  Numbi
//
//  Created by Vadym on 05.05.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MathParser

class NewNoteViewController: UIViewController {
    
    private let noteView = NewNoteView()
    private let noteViewModel = NoteViewModel()
    private let throttleIntervalInMilliseconds = 10
    private let disposeBag = DisposeBag()
    let cell = NewNoteTableViewCell()
    
    override func loadView() {
        self.view = noteView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        noteView.tableView.register(NewNoteTableViewCell.self, forCellReuseIdentifier: noteViewModel.NoteCellId)
        setupCellConfiguration()
        textViewObserver()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.noteView.tableView.reloadData()
//        }
        
    }
    
    func setupCellConfiguration() {
        NoteViewModel.rxData
            .bind(to: noteView.tableView
                .rx
                .items(cellIdentifier: noteViewModel.NoteCellId, cellType: NewNoteTableViewCell.self)) { row, element, cell in
                    cell.getText(text: element)
        }
        .disposed(by: disposeBag)
    }
    
    func textViewObserver() {
//        noteView.textView.rx.text
//            .subscribe(onNext: {
//                guard let ch = $0?.last else { return }
//
//                let expr = Parser.parse(string: checker)
//                let exprValue = expr?.evaluate()
//                cell.resultLabel.text = NSDecimalNumber(decimal: exprValue ?? 0).stringValue
//
//                self.atrString(str: $0, textView: cell.textView)
//
//                if ch == "\n" {
//                    print("return")
//                    let cell = NewNoteTableViewCell()
//                    cell.label.text?.append(ch)
//                }
//            })
//            .disposed(by: self.disposeBag)
        
        noteView.textView
            .rx
            .text
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(self.throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                //guard let c = $0 else { return }
                let checker = ($0 ?? "").replacingOccurrences(of: "% of ", with: "*0.01*")
                
                let expr = Parser.parse(string: checker)
                let exprValue = expr?.evaluate()
                var update = NoteViewModel.rxData.value
                update[0] = NSDecimalNumber(decimal: exprValue ?? 0).stringValue
                NoteViewModel.rxData.accept(update)
                
                //self.cell.label.text = NSDecimalNumber(decimal: exprValue ?? 0).stringValue

            })
            .disposed(by: self.disposeBag)
    }
    
    func rowInfo(textView: UITextView) {
        let layoutManager:NSLayoutManager = textView.layoutManager
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
    }
}
