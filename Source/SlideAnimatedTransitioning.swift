//
//  SlideAnimatedTransitioning.swift
//  PopItUp
//
//  Created by fritzgerald muiseroux on 18/03/2018.
//  Copyright © 2018 MUISEROUX Fritzgerald. All rights reserved.
//

import UIKit

public enum PopupSlideAnimationOrigin {
    case left
    case right
    case top
    case bottom
}

public protocol PopupAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    var isDismissed: Bool { get set }
    func interactiveTransitionning(inView view: UIView, forController controller: UIViewController) -> UIViewControllerInteractiveTransitioning?
}

public extension PopupAnimatedTransitioning {
    func interactiveTransitionning(inView view: UIView, forController controller: UIViewController) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
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
