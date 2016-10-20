//
//  keyboardDissapear.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/19/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
