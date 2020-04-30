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
    
    private let disposeBag = DisposeBag()
    
    let noteView = NoteView()
    let noteViewModel = NoteViewModel()
    let dataSource = NoteDataSource()
    let tableData = GenericDataSource.rxData
    private let throttleIntervalInMilliseconds = 500
    
    override func loadView() {
        self.view = noteView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = noteViewModel.title
        
        noteView.tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: dataSource.cellId)
        
        setupCellConfiguration()
        
        //noteView.tableView.dataSource = self.dataSource
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func setupCellConfiguration() {
        tableData
            .bind(to: noteView.tableView
                .rx
                .items(cellIdentifier: dataSource.cellId, cellType: NoteTableViewCell.self)) { row, element, cell in
                    DispatchQueue.main.async {
                        cell.getText(text: element)
                        
                        cell.textView
                            .rx
                            .text
                            .observeOn(MainScheduler.asyncInstance)
                            .distinctUntilChanged()
                            .throttle(.milliseconds(self.throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
                            .subscribe(onNext: {
                                
                                let checker = ($0 ?? "").replacingOccurrences(of: "% of ", with: "*0.01*")
                                
                                let expr = Parser.parse(string: checker)
                                let exprValue = expr?.evaluate()
                                cell.resultLabel.text = NSDecimalNumber(decimal: exprValue ?? 0).stringValue
                            })
                            .disposed(by: self.disposeBag)

                        if !cell.textView.isFirstResponder {
                            UIView.performWithoutAnimation {
                                cell.textView.becomeFirstResponder()
                            }
                        }
                    }
                    cell.textChanged { [weak self] (_) in
                        if let self = self {
                            self.noteView.tableView.beginUpdates()
                            self.noteView.tableView.endUpdates()
                        }
                    }
        }
            .disposed(by: disposeBag) //5
    }
}
