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
            
            likeCount += 1
            
            likesCountLabel.text = String(likeCount)
            
        } else {
            
            heartButton.setBackgroundImage(notTappedHeart, for: .normal)
            heartButton.tintColor = .gray
            likesCountLabel.textColor = UIColor.gray
            
            likeCount -= 1
            
            likesCountLabel.text = String(likeCount)
        }
    }
    
}
