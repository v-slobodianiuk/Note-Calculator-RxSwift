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
    
    override func loadView() {
        self.view = noteView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        noteView.tableView.register(NewNoteTableViewCell.self, forCellReuseIdentifier: noteViewModel.NoteCellId)
        setupCellConfiguration()
        
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
