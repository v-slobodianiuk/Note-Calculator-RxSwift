//
//  ListViewController.swift
//  Numbi
//
//  Created by Vadym on 04.05.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    private let listView = NewNoteView()
    
    override func loadView() {
        self.view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("deinited")
    }
}
