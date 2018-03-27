//
//  PickerViewController.swift
//  PopItUp_iOS_sample
//
//  Created by fritzgerald muiseroux on 25/03/2018.
//  Copyright © 2018 fritzgerald muiseroux. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {

    var values: [String] = [] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }

    var completedWithIndex: ((Int) -> Void)?

    @IBOutlet private weak var pickerView: UIPickerView!

    convenience init(values: [String]) {
        self.init()
        self.values = values
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction
    func doneTouchUpInside(_ sender: Any) {
        completedWithIndex?(pickerView.selectedRow(inComponent: 0))
        dismiss(animated: true, completion: nil)
    }
}

extension PickerViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
}

extension PickerViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row]
    }
}
