//
//  UIViewController+PopitUp.swift
//  PopItUp
//
//  Created by fritzgerald muiseroux on 19/03/2018.
//  Copyright © 2018 MUISEROUX Fritzgerald. All rights reserved.
//

import UIKit

public extension UIViewController {

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
