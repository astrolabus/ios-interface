//
//  CustomTransitionAnimator.swift
//  VK_client
//
//  Created by Полина Войтенко on 03.03.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class CustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        destination.view.transform = CGAffineTransform(translationX: source.view.frame.width, y: 0)
        
        UIView.addKeyframe(withRelativeStartTime: 0,
                           relativeDuration: 0.75,
                           animations: {
                            let translation = CGAffineTransform(translationX: -200, y: 0)
                            let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                            source.view.transform = translation.concatenating(scale)
        })
        UIView.addKeyframe(withRelativeStartTime: 0.2,
                           relativeDuration: 0.4,
                           animations: {
                               let translation = CGAffineTransform(translationX: source.view.frame.width / 2, y: 0)
                               let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
                               destination.view.transform = translation.concatenating(scale)
        })

        UIView.addKeyframe(withRelativeStartTime: 0.6,
                           relativeDuration: 0.4,
                           animations: {
                               destination.view.transform = .identity
        })
        
        

    }
}
