//
//  ViewController.swift
//  PopItUp_iOS_sample
//
//  Created by fritzgerald muiseroux on 25/03/2018.
//  Copyright © 2018 fritzgerald muiseroux. All rights reserved.
//

import UIKit
import PopItUp

enum RowDefinition {
    case backgroundType(PopupBackgroundStyle)
    case blurStyle(UIBlurEffectStyle)
    case colorPicker(UIColor)
    case transitionType(PopupTransition)
    case slideOrigin(PopupSlideAnimationOrigin)
    case newConstraint
    case constraint(PopupConstraint)
}

extension UIBlurEffectStyle {
    var strValue: String {
        switch self {
        case .dark:
            return "dark"
        case .extraLight:
            return "extraLight"
        case .light:
            return "light"
        case .prominent:
            return "prominent"
        case .regular:
            return "regular"
        default:
            return ""
        }
    }

    static var allValues: [UIBlurEffectStyle] {
        return [.extraLight, .light, .dark, .regular, .prominent]
    }
}

extension PopupSlideAnimationOrigin {
    var strValue: String {
        switch self {
        case .bottom:
            return "bottom"
        case .left:
            return "left"
        case .right:
            return "right"
        case .top:
            return "top"
        }
    }

    static var allValues: [PopupSlideAnimationOrigin] {
        return [.bottom, .left, .right, .top]
    }
}

extension PopupConstraint {
    var strValue: String {
        switch self {
        case .bottom(let value):
            return "bottom: \(value)"
        case .top(let value):
            return "top: \(value)"
        case .leading(let value):
            return "leading: \(value)"
        case .trailing(let value):
            return "trailing: \(value)"
        case .width(let value):
            return "width: \(value)"
        case .height(let value):
            return "height: \(value)"
        }
    }
}

class ViewController: UIViewController {

    var rowsDefinition = [RowDefinition]() {
        didSet {
            tableView.reloadData()
        }
    }

    var backgroundType: PopupBackgroundStyle = .blur(.dark) {
        didSet { updateRows() }
    }
    var transitionType: PopupTransition = .slide(.top) {
        didSet { updateRows() }
    }
    var popupConstraints: [PopupConstraint] = [] {
        didSet { updateRows() }
    }

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        updateRows()
    }

    @IBAction
    func showPopup(_ sender: Any) {
        presentPopup(TestPopupViewController(),
                     animated: true,
                     backgroundStyle: backgroundType,
                     constraints: popupConstraints,
                     transitioning: transitionType,
                     autoDismiss: true,
                     completion: nil)
    }

    func updateRows() {
        rowsDefinition = buildRowDefinition()
    }

    func buildRowDefinition() -> [RowDefinition] {
        var rows = [RowDefinition]()
        rows.append(.backgroundType(backgroundType))

        switch backgroundType {
        case .blur(let value):
            rows.append(.blurStyle(value))
        case .color(let color):
            rows.append(.colorPicker(color))
        }

        rows.append(.transitionType(transitionType))
        switch transitionType {
        case .slide(let value):
            rows.append(.slideOrigin(value))
        case .zoom, .custom:
            break
        }

        rows.append(.newConstraint)
        popupConstraints.forEach { rows.append(.constraint($0)) }

        return rows
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cellDesc = self.rowsDefinition[indexPath.row]
        switch cellDesc {
        case .backgroundType:
            selectBackgroundType()
        case .blurStyle:
            selectBlurType()
        case .transitionType:
            selecTransionType()
        case .slideOrigin:
            selectSlideOrigin()
        case .newConstraint:
            showNewConstraint()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func selectBackgroundType() {
        let picker = PickerViewController(values: ["Blur", "Color"])
        picker.completedWithIndex = { index in
            if index == 0 {
                self.backgroundType = .blur(.dark)
            } else {
                self.backgroundType = .color(.black)
            }
        }
        presentPopup(picker,
                     animated: true,
                     backgroundStyle: .color(UIColor.black.withAlphaComponent(0.3)),
                     constraints: [.bottom(0), .trailing(0), .leading(0)],
                     transitioning: .slide(.bottom),
                     autoDismiss: true)

    }

    func selectBlurType() {
        let picker = PickerViewController(values: UIBlurEffectStyle.allValues.map { $0.strValue })
        picker.completedWithIndex = { index in

            if let effect = UIBlurEffectStyle(rawValue: index) {
                self.backgroundType = .blur(effect)
            }
        }
        presentPopup(picker,
                     animated: true,
                     backgroundStyle: .color(UIColor.black.withAlphaComponent(0.3)),
                     constraints: [.bottom(0), .trailing(0), .leading(0)],
                     transitioning: .slide(.bottom),
                     autoDismiss: true)
    }

    func selecTransionType() {
        let picker = PickerViewController(values: ["Slide", "Zoom"])
        picker.completedWithIndex = { index in
            if index == 0 {
                self.transitionType = .slide(.top)
            } else {
                self.transitionType = .zoom
            }
        }
        presentPopup(picker,
                     animated: true,
                     backgroundStyle: .color(UIColor.black.withAlphaComponent(0.3)),
                     constraints: [.bottom(0), .trailing(0), .leading(0)],
                     transitioning: .slide(.bottom),
                     autoDismiss: true)
    }

    func selectSlideOrigin() {
        let picker = PickerViewController(values: PopupSlideAnimationOrigin.allValues.map { $0.strValue })
        picker.completedWithIndex = { index in
            switch index {
            case 0:
                self.transitionType = .slide(.bottom)
            case 1:
                self.transitionType = .slide(.left)
            case 2:
                self.transitionType = .slide(.right)
            case 3:
                self.transitionType = .slide(.top)
            default:
                break
            }
        }
        presentPopup(picker,
                     animated: true,
                     backgroundStyle: .color(UIColor.black.withAlphaComponent(0.3)),
                     constraints: [.bottom(0), .trailing(0), .leading(0)],
                     transitioning: .slide(.bottom),
                     autoDismiss: true)
    }

    func showNewConstraint() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "newConstraint") as? UINavigationController else {
            return
        }
        
        if let newContraintVC = vc.viewControllers[0] as? NewConstraintViewController {
            newContraintVC.didAddConstraint = { constraint in
                self.popupConstraints.append(constraint)
            }
        }
        self.presentPopup(vc, animated: true, constraints: [.width(280), .height(300)])
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsDefinition.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celldata = rowsDefinition[indexPath.row]
        switch celldata {
        case .backgroundType(let value):
            var strValue = "blur"
            if case PopupBackgroundStyle.color = value {
                strValue = "color"
            }
            return keyValueCell(from: tableView, indexPath: indexPath, key: "Background", value: strValue)
        case .blurStyle(let effect):
            return keyValueCell(from: tableView, indexPath: indexPath, key: "Blur Style", value: effect.strValue)
        case .colorPicker(let color):
            return colorTableViewCell(from: tableView, indexPath: indexPath)
        case .transitionType(let transition):
            var strValue = "slide"
            if case PopupTransition.zoom = transition {
                strValue = "zoom"
            }
            return keyValueCell(from: tableView, indexPath: indexPath, key: "Transion type", value: strValue)
        case .slideOrigin(let origin):
            return keyValueCell(from: tableView, indexPath: indexPath, key: "Transion Origin", value: origin.strValue)
        case .newConstraint:
            return tableView.dequeueReusableCell(withIdentifier: "newConstraint", for: indexPath)
        case .constraint(let constraint):
            return keyValueCell(from: tableView, indexPath: indexPath, key: "Constraint", value: constraint.strValue)
        }
    }

    func keyValueCell(from tableView: UITableView, indexPath: IndexPath, key: String, value: String) -> KeyValueTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KeyValueTableViewCell", for: indexPath) as? KeyValueTableViewCell else {
            fatalError()
        }
        cell.configure(with: key, value: value)
        return cell
    }

    func colorTableViewCell(from tableView: UITableView, indexPath: IndexPath) -> ColorTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ColorTableViewCell", for: indexPath) as? ColorTableViewCell else {
            fatalError()
        }

        cell.colorDidChange = { color in
            self.backgroundType = .color(color)
        }
        return cell
    }
}

