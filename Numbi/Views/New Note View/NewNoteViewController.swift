//
//  NewNoteViewController.swift
//  Numbi
//
//  Created by Vadym on 04.05.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewNoteViewController: UIViewController {
    
    var viewModel: NoteViewModel
    
    private let noteView = NewNoteView()
    private let realmService = RealmService()
    private let disposeBag = DisposeBag()
    private let throttleIntervalInMilliseconds = 1000
    
    init(viewModel: NoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = noteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NoteViewModel.lastNote = viewModel.defaults.integer(forKey: viewModel.userDefaultsKey)
        viewModel.appStart(at: NoteViewModel.lastNote)
        realmService.loadData(noteView.leftTextView, row: NoteViewModel.lastNote)
        setupNavItems()
        setupInputView()
        
        noteView.leftTextView.becomeFirstResponder()
    }
    
    func setupNavItems() {
        self.title = viewModel.title
        
        if #available(iOS 13, *) {
            let leftButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(listPressed))
            let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newNotePressed))
            self.navigationItem.leftBarButtonItem = leftButton
            self.navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    @objc func newNotePressed() {
        realmService.addNewNote()
        NoteViewModel.lastNote = realmService.last()
        realmService.loadData(noteView.leftTextView, row: realmService.last())
    }
    
    @objc func listPressed() {
        let menuVC = ListViewController(viewModel: ListViewModel())
        menuVC.selectedRow.subscribe(onNext: { [weak self] selectedRow in
            guard let self = self else { return }
            self.realmService.loadData(self.noteView.leftTextView, row: selectedRow)
            NoteViewModel.self.lastNote = selectedRow
            self.viewModel.defaults.set(NoteViewModel.lastNote, forKey: self.viewModel.userDefaultsKey)
        })
            .disposed(by: disposeBag)
        self.navigationController?.pushViewController(menuVC, animated: true)
    }
    
    func setupInputView() {
        noteView.leftTextView.rx.text
            //            .observeOn(MainScheduler.asyncInstance)
            //            .distinctUntilChanged()
            //            .throttle(.milliseconds(self.throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                
                self.noteView.rightTextView.text = self.viewModel.getResult(input: text)
                self.atrString(str: text, textView: self.noteView.leftTextView)
                
                self.realmService.saveData(input: text)
            })
            .disposed(by: self.disposeBag)
    }
    
    func  customizeColor(string: String, color: UIColor) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: color,
        ]
        
        return NSMutableAttributedString(string: string, attributes: attributes)
    }
    
    func atrString(str: String?, textView: UITextView) {
        
        guard let text = str else { return }
        let aString = self.customizeColor(string: "\(text)", color: UIColor.black)
        
        let replacements = [
            //#"\D"#: UIColor.systemPurple, // Буквы
            //#"[\D&&[^\W]]"#: UIColor.systemPurple, // Буквы
            #"[\W&&[^#]]"#: UIColor.systemRed, // Символы
            #"\d"#: UIColor.systemBlue, // Цифры
            "[#]{2,}(.*)":UIColor.systemOrange, // ## для комментов
        ]
        
        for (pattern, attributes) in replacements {
            let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(text.startIndex..., in: text)
            let matches = regex.matches(in: text, options: [], range: range)
            for match in matches {
                let matchRange = match.range
                aString.addAttribute(NSAttributedString.Key.foregroundColor, value: attributes, range: matchRange)
            }
        }
        textView.attributedText = aString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
