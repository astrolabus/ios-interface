//
//  CustonPopAnimator.swift
//  VK_client
//
//  Created by Полина Войтенко on 03.03.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class CustonPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
            transitionContext.containerView.sendSubviewToBack(destination.view)
            
            destination.view.frame = source.view.frame
            
            let translation = CGAffineTransform(translationX: -source.view.frame.width / 2, y: source.view.frame.width * 1.6)
            let rotation = CGAffineTransform(rotationAngle: 1.57)
            destination.view.transform = translation.concatenating(rotation)
            
            UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                    delay: 0,
                                    options: .calculationModePaced,
                                    animations: {
                                        UIView.addKeyframe(withRelativeStartTime: 0,
                                                           relativeDuration: 0.75,
                                                           animations: {
                                                            let translation = CGAffineTransform(translationX: source.view.frame.width / 2, y: source.view.frame.width * 1.6)
                                                            let rotation = CGAffineTransform(rotationAngle: -1.57)
                                                            source.view.transform = translation.concatenating(rotation)
                                        })
                                        UIView.addKeyframe(withRelativeStartTime: 0.6,
                                                           relativeDuration: 0.4,
                                                           animations: {
                                                               destination.view.transform = .identity
                                        })
                                        
                                        
            }) { finished in
                if finished && !transitionContext.transitionWasCancelled {
                    source.removeFromParent()
                } else if transitionContext.transitionWasCancelled {
                    destination.view.transform = .identity
                }
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
            }
        }

}
