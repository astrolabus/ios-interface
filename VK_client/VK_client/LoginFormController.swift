//
//  LoginFormController.swift
//  VK_client
//
//  Created by Полина Войтенко on 30.01.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class LoginFormController: UIViewController {

    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        if let login = loginInput.text, let password = passwordInput.text {
            if login == "login" && password == "passw0rd" {
                print("You are in.")
            } else {
                print("Wrong.")
            }
        } else {
            print("Something is missig. Try again.")
        }
    }
    
}
