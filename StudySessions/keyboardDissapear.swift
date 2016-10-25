//
//  keyboardDissapear.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/19/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit

// This class should be used in all cases where we are using a keyboard. 
// It allows users to make the keyboard dissappear if they click somewhere.
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
