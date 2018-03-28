//
//  SlideAnimatedTransitioning.swift
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

public enum PopupSlideAnimationOrigin {
    case left
    case right
    case top
    case bottom
}

class SlideAnimatedTransitioning: NSObject, PopupAnimatedTransitioning {

    private let duration: TimeInterval = 0.35
    var isDismissed: Bool = false
    let direction: PopupSlideAnimationOrigin
    
    init(_ direction: PopupSlideAnimationOrigin) {
        self.direction = direction
    }

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
        let originPosition = translation(for: direction,
                                            contentView: popup.containedViewContoller.view,
                                            inContainer: popup.view)
        let originTranslation = CGAffineTransform(translationX: originPosition.x, y: originPosition.y)

        let finalAlpha: CGFloat
        if false == isDismissed {
            toVC.view.frame = container.frame
            toVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            container.addSubview(toVC.view)
            popup.backgroundView.alpha = 0
            popup.containedViewContoller.view.transform = originTranslation
            finalAlpha = 1
        } else {
            finalAlpha = 0
            popup.containedViewContoller.view.transform = CGAffineTransform.identity
        }

        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
            popup.backgroundView.alpha = finalAlpha
            if self.isDismissed {
                popup.containedViewContoller.view.transform = originTranslation
            } else {
                popup.containedViewContoller.view.transform = CGAffineTransform.identity
            }
        }) { (finished) in
            if false == transitionContext.transitionWasCancelled,
                self.isDismissed {
                fromVC.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

    func translation(for origin: PopupSlideAnimationOrigin, contentView: UIView, inContainer containerView: UIView) -> CGPoint {
        switch origin {
        case .left:
            let trX = -contentView.frame.maxX
            return CGPoint(x: trX, y: 0)
        case .right:
            let trX = containerView.frame.width - contentView.frame.minX
            return CGPoint(x: trX, y: 0)
        case .top:
            let trY = -contentView.frame.maxY
            return CGPoint(x: 0, y: trY)
        case .bottom:
            let trY = containerView.frame.height - containerView.frame.minY
            return CGPoint(x: 0, y: trY)
        }
    }
}
