//
//  TableViewCell.swift
//  Numbi
//
//  Created by Vadym on 23.04.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    var resultView = UIView()
    var textView = UITextView()
    var resultLabel = UILabel()
    
    var textChanged: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView.delegate = self
        setupUI()
        constraints()
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    private func setupUI() {
        self.contentView.addSubview(textView)
        self.contentView.addSubview(resultView)
        resultView.addSubview(resultLabel)
        
        textView.text = "Text View text"
        textView.isScrollEnabled = false
        resultView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        resultLabel.text = "Result Label Text"
        resultLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func constraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        textView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        
        resultView.translatesAutoresizingMaskIntoConstraints = false
        resultView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
        resultView.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 0).isActive = true
        resultView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
        
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.bottomAnchor.constraint(equalTo: self.resultView.bottomAnchor, constant: 0).isActive = true
        resultLabel.leadingAnchor.constraint(equalTo: self.resultView.leadingAnchor, constant: 10).isActive = true
        resultLabel.trailingAnchor.constraint(equalTo: self.resultView.trailingAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension NoteTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
    }
}
