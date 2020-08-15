//
//  NumbiKeyboard.swift
//  Numbi
//
//  Created by Vadym on 30.04.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NumbiKeyboard: UIView {
    
    private let disposeBag = DisposeBag()
    
    private let keyTitleSubject = PublishSubject<String>()
    var keyTitle: Observable<String> {
        return keyTitleSubject.asObservable()
    }
    
    lazy var mainStackView = UIStackView()
    lazy var topStackView = UIStackView()
    lazy var bottomStackView = UIStackView()
    lazy var firstInputBoardStackView = UIStackView()
    lazy var firstHorizontalStackView = UIStackView()
    lazy var secondHorizontalStackView = UIStackView()
    lazy var thirdHorizontalStackView = UIStackView()
    lazy var fourthHorizontalStackView = UIStackView()
    lazy var scrollView = UIScrollView()
    lazy var testView1 = UIView()
    lazy var testView2 = UIView()
    lazy var testView3 = UIView()
    lazy var pageControl = UIPageControl()
    
    let orangeArray = [3, 4, 8, 9, 13, 14, 18, 19]
    lazy var slides = [UIView] ()
    
    lazy var buttons: [KeyboardButton] = []
    lazy var buttonsTitle = ["7", "8", "9", "🙂", "🙃",
                        "4", "5", "6", "×", "÷",
                        "1", "2", "3", "+", "−",
                        ".", "0", "-", " ", " ",
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for _ in 1...20 {
            buttons.append(KeyboardButton())
        }
        setupUI()
        constraints()
        addToStackView()
        
        searchInSubviews(firstHorizontalStackView, buttonsArray: orangeArray)
        searchInSubviews(secondHorizontalStackView, buttonsArray: orangeArray)
        searchInSubviews(thirdHorizontalStackView, buttonsArray: orangeArray)
        searchInSubviews(fourthHorizontalStackView, buttonsArray: orangeArray)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constraints()
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor(red: 210/255, green: 213/255, blue: 219/255, alpha: 1.0)
        
        self.addSubview(mainStackView)
        mainStackView.addArrangedSubview(topStackView)
        mainStackView.addArrangedSubview(bottomStackView)
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.spacing = 0
        
        firstInputBoardStackView.axis = .vertical
        firstInputBoardStackView.alignment = .fill
        firstInputBoardStackView.distribution = .fillEqually
        firstInputBoardStackView.spacing = 8
        
        for (i, button) in buttons.enumerated() {
            button.setTitle("\(buttonsTitle[i])", for: .normal)
            button.tag = i
            
            button.rx.tap.bind {
                self.tappedButton(sender: button)
            }
            .disposed(by: disposeBag)
            
            button.tintColor = .black
        }
        
        if #available(iOS 13, *) {
            buttons[18].setImage(UIImage(systemName: "delete.left"), for: .normal)
            buttons[19].setImage(UIImage(systemName: "return"), for: .normal)
        }
        
        topStackView.addArrangedSubview(scrollView)
        bottomStackView.addArrangedSubview(pageControl)
        
        testView1.addSubview(firstInputBoardStackView)
        
        setupHorizontalStackView(for: firstHorizontalStackView)
        setupHorizontalStackView(for: secondHorizontalStackView)
        setupHorizontalStackView(for: thirdHorizontalStackView)
        setupHorizontalStackView(for: fourthHorizontalStackView)
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        testView2.backgroundColor = .red
        testView3.backgroundColor = .gray
        
        var leadingAnchor = self.scrollView.leadingAnchor
        
        let testViewArray = [testView1, testView2, testView3]
        
        for view in testViewArray {
            view.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(view)
            
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
            view.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 0).isActive = true
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0).isActive = true
            
            leadingAnchor = view.trailingAnchor
        }
        
        self.scrollView.trailingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        scrollView.rx.didScroll.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let pageIndex = round(self.scrollView.contentOffset.x/self.frame.width)
            self.pageControl.currentPage = Int(pageIndex)
        })
            .disposed(by: disposeBag)
        
        pageControl.numberOfPages = testViewArray.count
        pageControl.currentPage = 0
    }
    
    private func constraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topStackView.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 0).isActive = true
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 0).isActive = true
        topStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 0).isActive = true
        topStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 0).isActive = true
        topStackView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: 0).isActive = true
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 0).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 0).isActive = true
        bottomStackView.bottomAnchor.constraint(equalTo: mainStackView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        bottomStackView.heightAnchor.constraint(equalToConstant: 39).isActive = true
        
        firstInputBoardStackView.translatesAutoresizingMaskIntoConstraints = false
        firstInputBoardStackView.topAnchor.constraint(equalTo: testView1.topAnchor, constant: 8).isActive = true
        firstInputBoardStackView.leadingAnchor.constraint(equalTo: testView1.leadingAnchor, constant: 5).isActive = true
        firstInputBoardStackView.trailingAnchor.constraint(equalTo: testView1.trailingAnchor, constant: -5).isActive = true
        firstInputBoardStackView.bottomAnchor.constraint(equalTo: testView1.bottomAnchor, constant: -5).isActive = true
    }
    
    func addToStackView() {
        for i in 0...4 {
            firstHorizontalStackView.addArrangedSubview(buttons[i])
        }
        
        for i in 5...9 {
            secondHorizontalStackView.addArrangedSubview(buttons[i])
        }
        
        for i in 10...14 {
            thirdHorizontalStackView.addArrangedSubview(buttons[i])
        }
        
        for i in 15...19 {
            fourthHorizontalStackView.addArrangedSubview(buttons[i])
        }
        
        firstInputBoardStackView.addArrangedSubview(firstHorizontalStackView)
        firstInputBoardStackView.addArrangedSubview(secondHorizontalStackView)
        firstInputBoardStackView.addArrangedSubview(thirdHorizontalStackView)
        firstInputBoardStackView.addArrangedSubview(fourthHorizontalStackView)
    }
    
    func setupHorizontalStackView(for stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
    }
    
    func searchInSubviews(_ views: UIView, buttonsArray: [Int]) {
        views.subviews.forEach { view in
            guard let button = view as? KeyboardButton else { return }
            if buttonsArray.contains(where: { buttons[$0] == button }) {
                button.defaultBackgroundColor = UIColor.systemBlue
                button.highlightBackgroundColor = UIColor.lightGray
            } else {
                button.defaultBackgroundColor = UIColor.white
                button.highlightBackgroundColor = UIColor.lightGray
            }
        }
    }
    
    func tappedButton(sender: UIButton) {
        guard let keyLabel = sender.titleLabel?.text else { return }
        keyTitleSubject.on(.next(keyLabel))
        
        guard let imageTitle = sender.currentImage?.description else { return }
        if imageTitle.contains("delete.left") {
            keyTitleSubject.on(.next("delete"))
        } else if imageTitle.contains("return") {
            keyTitleSubject.on(.next("return"))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
