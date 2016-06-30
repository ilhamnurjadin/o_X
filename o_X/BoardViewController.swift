//
//  BoardViewController.swift
//  o_X
//

import UIKit

class BoardViewController: UIViewController {
    
    // Subviews
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var playerCPUSwitch: UISwitch!
    
    // New
    //var gameObject = OXGame()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        statusLabel.text = OXGameController.sharedInstance.getStateInString()
        newGameButton.hidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Alert
        createAlert("Login Successful", submessage: "Welcome")
        
    }
    
    @IBAction func newGameButtonPressed(sender: UIButton) {
        
        print("New game button pressed.")
        restartGame()
        sender.hidden = true
        
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        print("Logout button pressed")
        
        UserController.sharedInstance.logout { (errorMessage: String?) in
            
        }
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        self.presentViewController(vc!, animated: true, completion: nil)
        
    }
    
    @IBAction func boxButtonPressed(sender: UIButton) {
        let buttonTag = sender.tag
        print("Button \(buttonTag) was pressed!")
        
        let temp:String = OXGameController.sharedInstance.playMove(buttonTag).rawValue
        
        sender.setTitle(temp, forState: .Normal)                                  // sets title of button to X or O, depending on who is playing
        sender.enabled = false                                                    // make buttons unclickable
        statusLabel.text = OXGameController.sharedInstance.getStateInString()     // Change status label
        
        endGame()
    }
    
    func endGame() {
        // Checking for game state - determining if game is over
        // This is still printed if game is over
        if OXGameController.sharedInstance.getCurrentGame().state() != OXGameState.InProgress {
            
            self.statusLabel.text = ""
            
            // CREATE ALERT
            // creates an alert (programatically as opposed to using storyboard)
            let gameOverAlert = UIAlertController(title: "Game Over!", message:  OXGameController.sharedInstance.getStateInString(), preferredStyle: UIAlertControllerStyle.Alert)
            
            // creating alert actions (buttons)
            let alertActionDismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: { (action) in
                // action in the input refers tot he alertActionRed object itself (self-referential)
                // it is assumed that when you run the code, the alertActionRed has already been created
                
                self.newGameButton.hidden = false
                
            })
            
            // add actions/buttons
            gameOverAlert.addAction(alertActionDismiss)
            
            // present the alert in the view
            self.presentViewController(gameOverAlert, animated: true, completion: nil)
            
            
            for subview in containerView.subviews {
                if let button = subview as? UIButton {
                    button.enabled = false
                }
            }
            
        }
    }
    
    func createAlert(titleMessage: String, submessage: String) {
        
        // creates an alert (programatically as opposed to using storyboard)
        let alert = UIAlertController(title: titleMessage, message:  submessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        // creating alert actions (buttons)
        let alertActionDismiss = UIAlertAction(title: "OK", style: .Cancel, handler: { (action) in
            // action in the input refers to the alertActionDismiss object itself (self-referential)
            // it is assumed that when you run the code, the alertActionDismiss has already been created
            
        })
        
        // add actions/buttons
        alert.addAction(alertActionDismiss)
        
        // present the alert in the view
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func restartGame() {
        OXGameController.sharedInstance.restartGame()
        statusLabel.text = OXGameController.sharedInstance.getStateInString()
        
        for subview in containerView.subviews {
            if let button = subview as? UIButton {
                // change title of buttons
                button.setTitle("", forState: .Normal)
                // make buttons clickable
                button.enabled = true
            }
        }
    }

}

