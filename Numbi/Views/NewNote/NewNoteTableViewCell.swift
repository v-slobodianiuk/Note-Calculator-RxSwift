//
//  NewNoteTableViewCell.swift
//  Numbi
//
//  Created by Vadym on 05.05.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit

class NewNoteTableViewCell: UITableViewCell {
    
    var label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        constraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setupUI() {
        label.textAlignment = .right
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        //label.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(label)
    }
    
    func getText(text: String) {
        label.text = text
    }
    
    private func constraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
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
