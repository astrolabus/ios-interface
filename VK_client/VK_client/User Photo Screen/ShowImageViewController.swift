//
//  ShowImageViewController.swift
//  VK_client
//
//  Created by Полина Войтенко on 29.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var currentPhoto: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.photoImageView.image = currentPhoto;
    }

}
