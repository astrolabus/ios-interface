//
//  ParentViewShadow.swift
//  VK_client
//
//  Created by Полина Войтенко on 18.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

@IBDesignable class ShadowContainer: UIView {
    
    @IBInspectable var radius: CGFloat = 5.0
    @IBInspectable var opacity: Float = 0.7
    @IBInspectable var color: CGColor = UIColor.black.cgColor

    func shadow() {
        layer.shadowOffset = CGSize(width: 2.0, height: 2.5)
        layer.shadowColor = color
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
    
}
