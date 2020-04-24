//
//  NoteDataSource.swift
//  Numbi
//
//  Created by Vadym on 24.04.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import Foundation
import UIKit

class GenericDataSource : NSObject {
    var data = [""]
}

class NoteDataSource: GenericDataSource, UITableViewDataSource{
    
    let cellId = "Note Cell"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteTableViewCell
        let data = self.data[indexPath.row]
        cell.resultLabel.text = data
        cell.textChanged {[weak tableView] (_) in
                    tableView?.beginUpdates()
                    tableView?.endUpdates()
        }
        return cell
    }
}
