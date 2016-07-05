//
//  UIViewController.swift
//  o_X
//
//  Created by Ilham Nurjadin on 7/5/16.
//  Copyright © 2016 iX. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func createAlert(titleMessage: String, submessage: String, onDismiss: (UIAlertAction) -> Void) {
        
        // creates an alert (programatically as opposed to using storyboard)
        let alert = UIAlertController(title: titleMessage, message:  submessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        // creating alert actions (buttons)
        let alertActionDismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: onDismiss)
        
        // add actions/buttons
        alert.addAction(alertActionDismiss)
        
        // present the alert in the view
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}