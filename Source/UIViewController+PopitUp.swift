//
//  UIViewController+PopitUp.swift
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

public extension UIViewController {

    /**
     Present a view controller modaly has a popup.

     By default the view is centered and it's size is determined with autolayout. the size and the position can overridden by adding new PopupConstraint.
     - parameters:
        - popupViewController: the view controller to display as a popup
        - animated: Pass true if the presentation should be animated. otherwise, false
        - backgroundStyle: the background to display behind the popup. can be either a color or a blur. (default is a black color with an opacity of 30%)
        - constraints: Constraints to apply to the popup.
        - transitioning: Transition to apply when presenting the view
        - autoDismiss: true if the popup can be dismiss by a tap outside is bounds, false otherwise
        - completion: The block to execute after the presentation finishes. This block has no return value and takes no parameters. You may specify nil for this parameter
    */
    public func presentPopup(_ popupViewController: UIViewController,
                             animated: Bool,
                             backgroundStyle: PopupBackgroundStyle = .color(UIColor.black.withAlphaComponent(0.3)),
                             constraints: [PopupConstraint] = [.leading(8), .trailing(8)],
                             transitioning: PopupTransition = .slide(.top),
                             autoDismiss: Bool = true,
                             completion: (() -> Void)? = nil) {
        let popup = PopUpViewController(backgroundStyle: backgroundStyle, popupViewController, constraints, transitioning, autoDismiss)
        present(popup, animated: animated, completion: completion)
    }
}
