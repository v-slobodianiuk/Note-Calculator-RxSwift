//
//  TestViewController.swift
//  Numbi
//
//  Created by Vadym on 23.04.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    let noteView = NoteView()
    let noteViewModel = NoteViewModel()
    let dataSource = NoteDataSource()
    
    override func loadView() {
        self.view = noteView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = noteViewModel.title
        
        noteView.tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: dataSource.cellId)
        
        noteView.tableView.dataSource = self.dataSource
    }
}
