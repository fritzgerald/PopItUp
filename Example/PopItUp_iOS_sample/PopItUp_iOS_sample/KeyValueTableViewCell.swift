//
//  KeyValueTableViewCell.swift
//  PopItUp_iOS_sample
//
//  Created by fritzgerald muiseroux on 26/03/2018.
//  Copyright © 2018 fritzgerald muiseroux. All rights reserved.
//

import UIKit

class KeyValueTableViewCell: UITableViewCell {

    @IBOutlet private var keyLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!

    func configure(with key: String, value: String) {
        self.keyLabel.text = key
        self.valueLabel.text = value
    }
}
