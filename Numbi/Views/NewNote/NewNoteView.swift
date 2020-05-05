//
//  NewNoteView.swift
//  Numbi
//
//  Created by Vadym on 05.05.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit

class NewNoteView: UIView {
    let tableView = UITableView()
    let textView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    private func setupUI() {
        if #available(iOS 13, *) {
            self.backgroundColor = .systemBackground
        } else {
            self.backgroundColor = .white
        }
        
        self.addSubview(textView)
        self.addSubview(tableView)
        
        textView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        tableView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
        
        textView.font = .systemFont(ofSize: 18)
//        textView.text = "10101010011001010101010101010101101010100110010101010101010101011010101001100101010101010101010110101010011001010101010101010101"
        
//        tableView.estimatedRowHeight = 85.0
//        tableView.rowHeight = UITableView.automaticDimension
        //tableView.rowHeight = UITableView.automaticDimension
        //tableView.separatorStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constraints()
    }
    
    private func constraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        textView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        tableView.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
