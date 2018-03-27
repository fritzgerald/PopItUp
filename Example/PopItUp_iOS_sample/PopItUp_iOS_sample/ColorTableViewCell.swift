//
//  ColorTableViewCell.swift
//  PopItUp_iOS_sample
//
//  Created by fritzgerald muiseroux on 26/03/2018.
//  Copyright © 2018 fritzgerald muiseroux. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!

    @IBOutlet weak var outputView: UIView!

    var red: CGFloat = 0.0 {
        didSet { updateColor() }
    }

    var green: CGFloat = 0.0 {
        didSet { updateColor() }
    }

    var blue: CGFloat = 0.0 {
        didSet { updateColor() }
    }

    var alphaComponent: CGFloat = 0.3 {
        didSet { updateColor() }
    }

    var color: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alphaComponent)
    }

    var colorDidChange: ((UIColor) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        redSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        blueSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        greenSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        alphaSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }

    @objc func sliderValueChanged(_ slider: UISlider) {
        switch slider {
        case redSlider:
            red = CGFloat(slider.value)
        case blueSlider:
            blue = CGFloat(slider.value)
        case greenSlider:
            green = CGFloat(slider.value)
        case alphaSlider:
            alphaComponent = CGFloat(slider.value)
        default:
            break
        }
    }

    func updateColor() {
        outputView.backgroundColor = color
        colorDidChange?(color)
    }
}
