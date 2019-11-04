//
//  PopupAnimatedTransitioning.swift
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

/** A custom protocol to add custom transitions to your popup */
public protocol PopupAnimatedTransitioning: UIViewControllerAnimatedTransitioning {

    /**
     A property that indicates whether the view controller is being
     dismissed or presented
    */
    var isDismissed: Bool { get set }

    /**
     return the popup interactive transitioning if any

     - parameters:
        - controller: the popup view controller presented by **presentPopup** method
    */
    func interactiveTransitionning(forController controller: UIViewController) -> UIViewControllerInteractiveTransitioning?
}

public extension PopupAnimatedTransitioning {
    func interactiveTransitionning(forController controller: UIViewController) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
