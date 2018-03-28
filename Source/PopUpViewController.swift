//
//  PopUpViewController.swift
//
//  Copyright 2018 Fritzgerald MUISEROUX
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

public enum PopupBackgroundStyle {
    case blur(UIBlurEffectStyle)
    case color(UIColor)
}

public enum PopupConstraint {
    case width(CGFloat)
    case height(CGFloat)
    case top(CGFloat)
    case trailing(CGFloat)
    case bottom(CGFloat)
    case leading(CGFloat)
}

extension Array where Element == PopupConstraint {
    public static func top(_ space: CGFloat) -> [PopupConstraint] {
        return [.top(space)]
    }

    public static func bottom(_ space: CGFloat) -> [PopupConstraint] {
        return [.bottom(space)]
    }

    public static func leading(_ space: CGFloat) -> [PopupConstraint] {
        return [.leading(space)]
    }

    public static func trailing(_ space: CGFloat) -> [PopupConstraint] {
        return [.trailing(space)]
    }

    public static func centered(width: CGFloat?, height: CGFloat?) -> [PopupConstraint] {
        var constraints = [PopupConstraint]()
        if let width = width {
            constraints.append(.width(width))
        }

        if let height = height {
            constraints.append(.height(height))
        }
        return constraints
    }
}

extension PopupBackgroundStyle {

    fileprivate func generateView() -> UIView {
        switch self {
        case .blur(let style):
            return createBlurView(style)
        case .color(let color):
            return generateView(with: color)
        }
    }

    private func generateView(with color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.isOpaque = false
        return view
    }

    private func createBlurView(_ style: UIBlurEffectStyle) -> UIView {
        let blurEffect = UIBlurEffect(style: style)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }
}

public enum PopupTransition {
    case slide(PopupSlideAnimationOrigin)
    case zoom
    case custom(PopupAnimatedTransitioning)
}

extension PopupTransition {
    func animationTransitioning() -> PopupAnimatedTransitioning {
        switch self {
        case .slide(let direction):
            return SlideAnimatedTransitioning(direction)
        case .zoom:
            return ZoomAnimatedTransitioning()
        case .custom(let transitioning):
            return transitioning
        }
    }
}

class PopUpViewController: UIViewController {

    let backgroundStyle: PopupBackgroundStyle
    let containedViewContoller: UIViewController
    let popupConstraints: [PopupConstraint]
    weak var backgroundView: UIView!
    let transitionning: PopupAnimatedTransitioning
    let autoDismiss: Bool
    let interactiveTransitionning: UIViewControllerInteractiveTransitioning?

    init(backgroundStyle: PopupBackgroundStyle,
         _ containedViewContoller: UIViewController,
         _ popupConstraints: [PopupConstraint],
         _ transition: PopupTransition,
         _ autoDismiss: Bool) {
        self.backgroundStyle = backgroundStyle
        self.containedViewContoller = containedViewContoller
        self.popupConstraints = popupConstraints
        self.autoDismiss = autoDismiss
        transitionning = transition.animationTransitioning()
        interactiveTransitionning = transitionning.interactiveTransitionning(forController: containedViewContoller)

        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .overCurrentContext
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented please call init(backgroundStyle:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the popup background
        view.backgroundColor = UIColor.clear

        let backgroundView = backgroundStyle.generateView()
        backgroundView.isUserInteractionEnabled = true
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.frame = view.frame
        view.addSubview(backgroundView)
        self.backgroundView = backgroundView

        if autoDismiss {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissCurrentPopup(_:)))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.isEnabled = true
            backgroundView.addGestureRecognizer(tapGesture)
        }

        setupContainedViewController()
    }

    @objc func dismissCurrentPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PopUpViewController {
    private func addDefaultConstraints(_ theView: UIView) {
        var constraints = [NSLayoutConstraint]()

        // make sure that the contained view cannot go outside the view margin bounds
        let leading = theView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor)
        let trailing = view.trailingAnchor.constraint(greaterThanOrEqualTo: theView.trailingAnchor)
        let top = theView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor)
        let bottom = view.bottomAnchor.constraint(greaterThanOrEqualTo: theView.bottomAnchor)

        constraints.append(leading)
        constraints.append(trailing)
        constraints.append(top)
        constraints.append(bottom)

        // Center the contained view by default
        let centerY = theView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        centerY.priority = .defaultLow
        constraints.append(centerY)

        let centerX = theView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        centerX.priority = .defaultLow
        constraints.append(centerX)

        NSLayoutConstraint.activate(constraints)
    }

    private func addCustomConstraints() {
        let constraints = popupConstraints.map { contraint -> NSLayoutConstraint in
            let theConstraint = layoutContraint(from: contraint)
            switch contraint {
            case .width, .height:
                break
            case .top, .trailing, .bottom, .leading:
                theConstraint.priority = .defaultHigh
            }
            return theConstraint
        }
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutContraint(from constraint: PopupConstraint) -> NSLayoutConstraint {
        switch constraint {
        case .width(let width):
            return containedViewContoller.view.widthAnchor.constraint(equalToConstant: width)
        case .height(let height):
            return containedViewContoller.view.heightAnchor.constraint(equalToConstant: height)
        case .leading(let space):
            return containedViewContoller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space)
        case .trailing(let space):
            return view.trailingAnchor.constraint(equalTo: containedViewContoller.view.trailingAnchor, constant: space)
        case .top(let space):
            return containedViewContoller.view.topAnchor.constraint(equalTo: view.topAnchor, constant: space)
        case .bottom(let space):
            return view.bottomAnchor.constraint(equalTo: containedViewContoller.view.bottomAnchor, constant: space)
        }
    }

    private func setupContainedViewController() {
        containedViewContoller.willMove(toParentViewController: self)
        containedViewContoller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containedViewContoller.view)
        addChildViewController(containedViewContoller)
        containedViewContoller.didMove(toParentViewController: self)

        addDefaultConstraints(containedViewContoller.view)
        addCustomConstraints()
    }
}

extension PopUpViewController: UIViewControllerTransitioningDelegate {

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionning.isDismissed = true
        return transitionning
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionning.isDismissed = false
        return transitionning
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return interactiveTransitionning
    }
}
