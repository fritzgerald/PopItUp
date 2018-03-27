//
//  TestPopupViewController.swift
//  PopItUp
//
//  Created by fritzgerald muiseroux on 16/03/2018.
//  Copyright © 2018 MUISEROUX Fritzgerald. All rights reserved.
//

import UIKit

class TestPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction
    func closeModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
