//
//  ZoomAnimatedTransitioning.swift
//  PopItUp
//
//  Created by fritzgerald muiseroux on 21/03/2018.
//  Copyright © 2018 MUISEROUX Fritzgerald. All rights reserved.
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
