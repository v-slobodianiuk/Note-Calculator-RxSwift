//
//  NoteTextView.swift
//  Numbi
//
//  Created by Vadym on 24.04.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit

class NoteTextView: UITextView {
    override func deleteBackward() {
        super.deleteBackward()
        guard GenericDataSource.rxData.value.count > 1 else { return }
        guard self.text == "" else { return }
        var update = GenericDataSource.rxData.value
        update.removeLast()
        GenericDataSource.rxData.accept(update)
    }
}
