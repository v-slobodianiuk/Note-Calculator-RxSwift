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
import RealmSwift
import RxRealm

class ListViewController: UIViewController {
    
    private let listView = ListView()
    let disposeBag = DisposeBag()
    
    //let noteViewModel = NoteViewModel()
    let realm = try! Realm()
    var data: Results<NoteData>!
    
    
    let array = Observable.just(["1", "2", "3"])
    
    //var data = Observable.just(NoteViewModel.realmArray)
    
    override func loadView() {
        self.view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "List Cell")
        
        data = realm.objects(NoteData.self)
        setupTable()
    }
    
    func setupTable() {
        print("setuped")
        //Observable.from(optional: data)
        array
            .bind(to: listView.tableView
          .rx
          .items(cellIdentifier: "List Cell", cellType: UITableViewCell.self)) { row, element, cell in
                  //cell.configureWithChocolate(chocolate: chocolate)
                    print(element)
                    cell.textLabel?.text = String(row)
        }
        .disposed(by: disposeBag)
    }
    
    deinit {
        print("deinited")
    }
}
