//
//  NoteTextView.swift
//  Numbi
//
//  Created by Vadym on 24.04.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit

class NoteTextView: UITextView {
    
    lazy var noteViewModel = NoteViewModel()
    
    override func deleteBackward() {
        super.deleteBackward()
        noteViewModel.previousCell(textView: self)
    }
}
