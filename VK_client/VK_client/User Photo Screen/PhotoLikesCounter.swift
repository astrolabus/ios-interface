//
//  PhotoLikesCounter.swift
//  VK_client
//
//  Created by Полина Войтенко on 18.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit


class PhotoLikesCounterControl: UIControl {
    
    var likeCount: Int = 0
    
    private var heartButton = UIButton(type: .system)
    private var likesCountLabel = UILabel()
    
    private let tappedHeart = UIImage(named: "tapped-heart")?.withRenderingMode(.alwaysTemplate)
    private let notTappedHeart = UIImage(named: "not-tapped-heart")?.withRenderingMode(.alwaysTemplate)
    
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
         super.init(frame: frame)
        self.setupLikesView()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupLikesView()
    }
    
    func setupLikesView() {
        
        heartButton.setBackgroundImage(notTappedHeart, for: .normal)
        heartButton.tintColor = .gray
        
        likesCountLabel.text = String(likeCount)
        likesCountLabel.textColor = UIColor.gray
        likesCountLabel.textAlignment = .right
        
        heartButton.addTarget(self, action: #selector(heartTapped(_:)), for: .touchUpInside)
        
        stackView = UIStackView(arrangedSubviews: [likesCountLabel, heartButton])
        
        self.addSubview(stackView)
        
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .fillEqually
        stackView.backgroundColor = UIColor.clear
        
        layer.backgroundColor = UIColor.clear.cgColor
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    @objc private func heartTapped(_ sender: UIButton) {
        
        if heartButton.tintColor == .gray {
            
            heartButton.setBackgroundImage(tappedHeart, for: .normal)
            heartButton.tintColor = .red
            likesCountLabel.textColor = UIColor.red
            
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                            self.heartButton.frame.size.width -= 5
                            self.heartButton.frame.size.height -= 5
            })
            
            likeCount += 1
            
            likesCountLabel.text = String(likeCount)
            
            likesCountLabel.transform = CGAffineTransform(translationX: -stackView.frame.height, y: 0)
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: [.curveEaseOut],
                           animations: {
                            self.likesCountLabel.transform = .identity
            })
            
        } else {
            
            heartButton.setBackgroundImage(notTappedHeart, for: .normal)
            heartButton.tintColor = .gray
            likesCountLabel.textColor = UIColor.gray
            
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                            self.heartButton.frame.size.width += 5
                            self.heartButton.frame.size.height += 5
            })
            
            likeCount -= 1
            
            likesCountLabel.text = String(likeCount)
            
            likesCountLabel.transform = CGAffineTransform(translationX:  -stackView.frame.height, y: 0)
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: [.curveEaseOut],
                           animations: {
                            self.likesCountLabel.transform = .identity
            })
        }
    }
    
}
