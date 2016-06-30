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
        
        // Do any additional setup after loading the view, typically from a nib.
        
        statusLabel.text = OXGameController.sharedInstance.getStateInString()
        newGameButton.hidden = true
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
        
        // sets title of button to X or O, depending on who is playing
        sender.setTitle(temp, forState: .Normal)
        // make buttons unclickable
        sender.enabled = false
        // Change status label
        statusLabel.text = OXGameController.sharedInstance.getStateInString()
        
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
        /*
        boxButton1.setTitle("", forState: UIControlState.Normal)
        boxButton2.setTitle("", forState: UIControlState.Normal)
        boxButton3.setTitle("", forState: UIControlState.Normal)
        boxButton4.setTitle("", forState: UIControlState.Normal)
        boxButton5.setTitle("", forState: UIControlState.Normal)
        boxButton6.setTitle("", forState: UIControlState.Normal)
        boxButton7.setTitle("", forState: UIControlState.Normal)
        boxButton8.setTitle("", forState: UIControlState.Normal)
        boxButton9.setTitle("", forState: UIControlState.Normal)
        */
    }

}

