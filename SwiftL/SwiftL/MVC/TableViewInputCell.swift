//
//  TableViewInputCell.swift
//  SwiftL
//
//  Created by kaisa-ios-001 on 2018/11/23.
//  Copyright © 2018年 Giga. All rights reserved.
//

import UIKit

protocol TableViewInputCellDelegate: class {
    func inputChanged(cell: TableViewInputCell, text: String)
}

class TableViewInputCell: UITableViewCell {

    weak var delegate: TableViewInputCellDelegate?
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        delegate?.inputChanged(cell: self, text: sender.text ?? "")
        
    }
}
