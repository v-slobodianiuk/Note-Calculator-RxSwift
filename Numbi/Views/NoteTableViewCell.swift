//
//  TableViewCell.swift
//  Numbi
//
//  Created by Vadym on 23.04.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MathParser

class NoteTableViewCell: UITableViewCell {
    
    private let disposeBag = DisposeBag()
    
    var noteViewModel = NoteViewModel()
    
    var resultView = UIView()
    var textView = NoteTextView()
    var resultLabel = UILabel()
    let keyboard = NumbiKeyboard()
    var keyboardBar: UIToolbar!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView.delegate = self
        setupUI()
        constraints()
    }
    
    func getText(text: String) {
        textView.text = text
    }
    
    private func setupUI() {
        self.contentView.addSubview(textView)
        self.contentView.addSubview(resultView)
        resultView.addSubview(resultLabel)
        
        textView.isScrollEnabled = false
        //textView.inputView = keyboard
        //textView.becomeFirstResponder()
        textView.font = .systemFont(ofSize: 18)
        
        
        keyboardBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let defaultKeyboard = UIBarButtonItem(title: "ABC", style: .plain, target: self, action: #selector(itemTapped))
        let numbiKeyboard = UIBarButtonItem(title: "123", style: .plain, target: self, action: #selector(itemTapped))
        keyboardBar.items = [defaultKeyboard, numbiKeyboard]
        textView.autocorrectionType = .no
        textView.inputAccessoryView = keyboardBar
        
        resultView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        resultLabel.textAlignment = .right
        resultLabel.font = UIFont.boldSystemFont(ofSize: 18)
        resultLabel.adjustsFontSizeToFitWidth = true
        
        keyboard.keyTitle
            .subscribe(onNext: { keyValue in
                self.keyWasTapped(character: keyValue)

            })
        .disposed(by: disposeBag)
        
//        textView.rx.didChange.subscribe(onNext: {
//            if self.textView.text.contains("\n") {
//                print("Contains")
//                self.noteViewModel.setupCell(self.textView)
//            }
//        })
//        .disposed(by: self.disposeBag)
    }
    
    @objc func itemTapped(sender: UIBarButtonItem) {
        guard let title = sender.title else { return }
        switch title {
        case "ABC":
            textView.inputView = nil
            textView.reloadInputViews()
        default:
            textView.inputView = keyboard
            textView.reloadInputViews()
        }
    }
    
    private func constraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        textView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.7).isActive = true
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
    
    func deleteWasTapped() {
        textView.deleteBackward()
    }
    
    func keyWasTapped(character: String) {
        
        guard character != " " else { return }
        
        switch character {
        case "+":
            textView.insertText("+")
        case "−":
            textView.insertText("-")
        case "×":
            textView.insertText("*")
        case "÷":
            textView.insertText("/")
        case "delete":
            deleteWasTapped()
        case "return":
            noteViewModel.setupCell(textView)
        default:
            textView.insertText(character)
        }
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            noteViewModel.setupCell(textView)
            return false
        }
        return true
    }
}
