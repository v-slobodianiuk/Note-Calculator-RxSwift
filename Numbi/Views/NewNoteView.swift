//
//  NewNote.swift
//  Numbi
//
//  Created by Vadym on 04.05.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit

class NewNoteView: UIView {
    
    var leftTextView = UITextView()
    var rightTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        constraints()
    }
    
    func setupUI() {
        self.backgroundColor = .white
        
        self.addSubview(leftTextView)
        self.addSubview(rightTextView)
        
        leftTextView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        rightTextView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.4)
        
        leftTextView.font = .systemFont(ofSize: 18)
        rightTextView.font = .systemFont(ofSize: 18)
        
        //leftTextView.text = "1001010101010101110101110110101001110101010101100111010101010101100101"
        //rightTextView.text = "1001010101010101110101110110101001110101010101100111010101010101100101"
    }
    
    func constraints() {
        leftTextView.translatesAutoresizingMaskIntoConstraints = false
        rightTextView.translatesAutoresizingMaskIntoConstraints = false
        
        leftTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        leftTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        leftTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        leftTextView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        
        rightTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        rightTextView.leadingAnchor.constraint(equalTo: leftTextView.trailingAnchor, constant: 0).isActive = true
        rightTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        rightTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
