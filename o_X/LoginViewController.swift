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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        UserController.sharedInstance.login(email: self.emailTextField.text!, password: self.passwordTextField.text!) { resultUser, errorMessage in
            
            // If there is an error logging in
            if resultUser == nil {
                self.createAlert("Login Unsuccessful", submessage: errorMessage!) { (action) in
                    // action in the input refers to the alertActionDismiss object itself (self-referential)
                    // it is assumed that when you run the code, the alertActionDismiss has already been created
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                }
                return
            }
            
            let storyboard = UIStoryboard(name: "Board", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            let application = UIApplication.sharedApplication()
            let window = application.keyWindow
            window?.rootViewController = vc
            
        }
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
