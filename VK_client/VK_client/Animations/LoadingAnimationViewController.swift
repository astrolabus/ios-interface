//
//  LoadingAnimationViewController.swift
//  VK_client
//
//  Created by Полина Войтенко on 28.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class LoadingAnimationViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var containerView: ShapeContainer!
    
    @IBOutlet weak var firstDot: ShapeContainer!
    @IBOutlet weak var secondDot: ShapeContainer!
    @IBOutlet weak var thirdDot: ShapeContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingAnimation()
        
        containerView.smoothedCorners()
        firstDot.circle()
        secondDot.circle()
        thirdDot.circle()
     }
    
    func loadingAnimation() {
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.firstDot.alpha = 0.0
        })
        UIView.animate(withDuration: 1.5, delay: 0.3, options: [.repeat, .autoreverse], animations: {
            self.secondDot.alpha = 0.0
        })
        UIView.animate(withDuration: 1.5, delay: 0.6, options: [.repeat, .autoreverse], animations: {
            self.thirdDot.alpha = 0.0
        })
    }

    
    
}
