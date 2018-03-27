//
//  NewConstraintViewController.swift
//  PopItUp_iOS_sample
//
//  Created by fritzgerald muiseroux on 27/03/2018.
//  Copyright © 2018 fritzgerald muiseroux. All rights reserved.
//

import UIKit
import PopItUp

class NewConstraintViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField?
    var selectedButtonIndex = 0
    var didAddConstraint: ((PopupConstraint) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let textfield = textfield {
            textfield.keyboardType = .decimalPad
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closePopup))
    }

    @objc func closePopup() {
        self.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVc = segue.destination as? NewConstraintViewController {
            destVc.selectedButtonIndex = selectedButtonIndex
            destVc.didAddConstraint = didAddConstraint
        }
    }

    @IBAction
    func didSelectConstraint(_ sender: UIButton) {
        selectedButtonIndex = sender.tag
        performSegue(withIdentifier: "gotoValue", sender: self)
    }

    @IBAction
    func didValidateConstraint(_ sender: UIButton) {
        guard let textfield = textfield,
            let text = textfield.text,
            let value = Double(text) else {
            return
        }

        var constraint: PopupConstraint?
        switch selectedButtonIndex {
        case 0:
            constraint = .leading(CGFloat(value))
        case 1:
            constraint = .trailing(CGFloat(value))
        case 2:
            constraint = .top(CGFloat(value))
        case 3:
            constraint = .bottom(CGFloat(value))
        case 4:
            constraint = .width(CGFloat(value))
        case 5:
            constraint = .height(CGFloat(value))
        default:
            break
        }

        if let constraint = constraint {
            didAddConstraint?(constraint)
            dismiss(animated: true, completion: nil)
        }
    }
}
