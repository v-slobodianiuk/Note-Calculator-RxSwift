//
//  NewNote.swift
//  Numbi
//
//  Created by Vadym on 04.05.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewNoteView: UIView {
    
    lazy var leftTextView = UITextView()
    lazy var rightTextView = UITextView()
    //lazy var rightTextView = UILabel()
    var keyboard: NumbiKeyboard!
    var keyboardBar: UIToolbar!
    private let disposeBag = DisposeBag()
    
    lazy var arbitraryValue: Int = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constraints()
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        
        self.addSubview(leftTextView)
        self.addSubview(rightTextView)
        
        leftTextView.font = .systemFont(ofSize: 18)
        rightTextView.font = .boldSystemFont(ofSize: 18)
        //rightTextView.numberOfLines = 0
        //rightTextView.adjustsFontSizeToFitWidth = true
        rightTextView.isEditable = false
        rightTextView.textAlignment = .right
        
        keyboardBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let defaultKeyboard = UIBarButtonItem(title: "ABC", style: .plain, target: self, action: #selector(itemTapped))
        let numbiKeyboard = UIBarButtonItem(title: "123", style: .plain, target: self, action: #selector(itemTapped))
        let hideKeyboard = UIBarButtonItem(title: "⌨️", style: .plain, target: self, action: #selector(itemTapped))
        // Flexible Space
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let leftwards = UIBarButtonItem(title: "←", style: .plain, target: self, action: #selector(itemTapped))
        // Fixed Space
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 20.0
        let rightwards = UIBarButtonItem(title: "→", style: .plain, target: self, action: #selector(itemTapped))
        keyboardBar.items = [defaultKeyboard, numbiKeyboard, hideKeyboard, flexibleSpace, leftwards, fixedSpace, rightwards]
        leftTextView.autocorrectionType = .no
        leftTextView.inputAccessoryView = keyboardBar
        
        keyboard = NumbiKeyboard()
        leftTextView.inputView = keyboard
        
        keyboard.keyTitle
            .subscribe(onNext: { [weak self] keyValue in
                guard let self = self else { return }
                self.keyWasTapped(character: keyValue)
            })
            .disposed(by: disposeBag)
        
    }
    
    @objc func itemTapped(sender: UIBarButtonItem) {
        guard let title = sender.title else { return }
        switch title {
        case "ABC":
            leftTextView.inputView = .none
            leftTextView.reloadInputViews()
        case "⌨️":
            leftTextView.resignFirstResponder()
        case "←":
            moveCursor(leftTextView, offset: -1)
        case "→":
            moveCursor(leftTextView, offset: +1)
        default:
            leftTextView.inputView = keyboard
            leftTextView.reloadInputViews()
        }
    }
    
    func moveCursor(_ textView: UITextView, offset: Int) {

        // only if there is a currently selected range
        guard let selectedRange = textView.selectedTextRange else { return }

        // and only if the new position is valid
        guard let newPosition = textView.position(from: selectedRange.start, offset: offset) else  { return }

        // set the new position
        textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
    }
    
    func deleteWasTapped() {
        leftTextView.deleteBackward()
    }
    
    func keyWasTapped(character: String) {
        
        guard character != " " else { return }
        
        switch character {
        case "+":
            leftTextView.insertText("+")
        case "−":
            leftTextView.insertText("-")
        case "×":
            leftTextView.insertText("*")
        case "÷":
            leftTextView.insertText("/")
        case "delete":
            deleteWasTapped()
        case "return":
            leftTextView.insertText("\n")
        default:
            leftTextView.insertText(character)
        }
    }
    
    private func constraints() {
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
