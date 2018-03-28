//
//  ZoomAnimatedTransitioning.swift
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

class ZoomAnimatedTransitioning: NSObject, PopupAnimatedTransitioning {
    var isDismissed: Bool = false
    private let duration: TimeInterval = 0.25

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let popup = (isDismissed ? fromVC : toVC) as? PopUpViewController else {
                return
        }

        let container = transitionContext.containerView
        let finalAlpha: CGFloat = 1.0
        let startAlpha: CGFloat = 0.0
        let finalScale = CGAffineTransform.identity
        let startScale = isDismissed ? CGAffineTransform(scaleX: 0.1, y: 0.1) : CGAffineTransform(scaleX: 0.25, y: 0.25)

        if false == isDismissed {
            toVC.view.frame = container.frame
            toVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            container.addSubview(toVC.view)
        }

        popup.backgroundView.alpha = isDismissed ? finalAlpha : startAlpha
        popup.containedViewContoller.view.transform = isDismissed ? finalScale : startScale

        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {[isDismissed = isDismissed] in
            popup.backgroundView.alpha = isDismissed ? startAlpha : finalAlpha
            popup.containedViewContoller.view.transform = isDismissed ? startScale : finalScale
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}
