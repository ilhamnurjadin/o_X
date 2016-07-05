//
//  RegisterViewController.swift
//  o_X
//
//  Created by Ilham Nurjadin on 6/30/16.
//  Copyright © 2016 iX. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

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
    
    @IBAction func registerButtonPressed(sender: UIButton) {
        
        //let tempUser: User = User(newEmail: self.emailTextField.text!, newPassword: self.passwordTextField.text!)
        
        UserController.sharedInstance.register(email: self.emailTextField.text!, password: self.passwordTextField.text!) { (resultUser: User?, errorMessage: String? ) in
            
            if resultUser == nil {
                self.createAlert("Registration Unsuccessful", submessage: errorMessage!) { action in
                    // action in the input refers to the alertActionDismiss object itself (self-referential)
                    // it is assumed that when you run the code, the alertActionDismiss has already been created
                    
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.emailTextField.becomeFirstResponder()
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
