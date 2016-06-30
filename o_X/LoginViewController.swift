//
//  LoginViewController.swift
//  o_X
//
//  Created by Ilham Nurjadin on 6/30/16.
//  Copyright © 2016 iX. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UserController.sharedInstance.currentUserExists())

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        UserController.sharedInstance.login(self.emailTextField.text!, password: self.passwordTextField.text!) { (resultUser: User?, errorMessage: String? ) in
            
            if errorMessage != nil {
                self.createAlert(errorMessage!)
                return
            }
            
            let storyboard = UIStoryboard(name: "Board", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.presentViewController(vc!, animated: true, completion: nil)
            
        }
    }
    
    func createAlert(errorMessage: String) {
        
         // creates an alert (programatically as opposed to using storyboard)
         let alert = UIAlertController(title: "Something went wrong", message:  errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
         
         // creating alert actions (buttons)
         let alertActionDismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: { (action) in
         // action in the input refers to the alertActionDismiss object itself (self-referential)
         // it is assumed that when you run the code, the alertActionDismiss has already been created
            
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            
         })
         
         // add actions/buttons
         alert.addAction(alertActionDismiss)
         
         // present the alert in the view
         self.presentViewController(alert, animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
