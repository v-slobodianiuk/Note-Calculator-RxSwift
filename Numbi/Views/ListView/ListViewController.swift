//
//  ListViewController.swift
//  Numbi
//
//  Created by Vadym on 04.05.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealm

class ListViewController: UIViewController {
    
    private let viewModel: ListViewModel
    private let listView = ListView()
    private let realmService = RealmService()
    private let privateSelectedRow = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    var selectedRow: Observable<Int> {
        return privateSelectedRow.asObservable()
    }
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getDataCell()
        removeEmpty()
        
        listView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: viewModel.cell)
        
        setupNavItems()
        setupTable()
        setupCellTapHandling()
    }
    
    func removeEmpty() {
        realmService.removeData()
        self.privateSelectedRow.onNext(realmService.last())
    }
    
    func setupNavItems() {
        title = viewModel.title
        
        if #available(iOS 13, *) {
            let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newNotePressed))
            self.navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    @objc func newNotePressed() {
        realmService.addNewNote()
        
        self.privateSelectedRow.onNext(realmService.last())
        self.privateSelectedRow.onCompleted()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setupTable() {
        Observable.array(from: viewModel.data)
            .bind(to: listView.tableView
                .rx
                .items(cellIdentifier: viewModel.cell, cellType: UITableViewCell.self)) { row, element, cell in
                    cell.textLabel?.text = element.noteText
        }
        .disposed(by: disposeBag)
    }
    
    func setupCellTapHandling() {
        listView.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.privateSelectedRow.onNext(indexPath.row)
                self.privateSelectedRow.onCompleted()
                self.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
