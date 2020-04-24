//
//  NoteView.swift
//  Numbi
//
//  Created by Vadym on 24.04.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit

class NoteView: UIView {
    
    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        if #available(iOS 13, *) {
            self.backgroundColor = .systemBackground
        } else {
            self.backgroundColor = .white
        }
        self.addSubview(tableView)
        tableView.separatorStyle = .none
    }
    
    private func constraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
}
