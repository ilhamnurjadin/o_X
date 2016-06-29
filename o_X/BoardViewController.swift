//
//  BoardViewController.swift
//  o_X
//

import UIKit

class BoardViewController: UIViewController {
    
    // Subviews
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var boxButton1: UIButton!
    @IBOutlet weak var boxButton2: UIButton!
    @IBOutlet weak var boxButton3: UIButton!
    @IBOutlet weak var boxButton4: UIButton!
    @IBOutlet weak var boxButton5: UIButton!
    @IBOutlet weak var boxButton6: UIButton!
    @IBOutlet weak var boxButton7: UIButton!
    @IBOutlet weak var boxButton8: UIButton!
    @IBOutlet weak var boxButton9: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    // New
    //var gameObject = OXGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func newGameButtonPressed(sender: UIButton) {
        print("New game button pressed.")
        restartGame()
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        print("Logout button pressed")
    }
    
    @IBAction func boxButtonPressed(sender: UIButton) {
        let buttonTag = sender.tag
        print("Button \(buttonTag) was pressed!")
        
        // sets title of button to X or O, depending on who is playing
        sender.setTitle(OXGameController.sharedInstance.playMove(buttonTag).rawValue, forState: .Normal)
        
        // Checking for game state - determining if game is over
        // This is still printed if game is over
        if OXGameController.sharedInstance.getCurrentGame().state() != OXGameState.InProgress {
            if OXGameController.sharedInstance.getCurrentGame().state() ==  OXGameState.Won {
                print("Congrats, \(OXGameController.sharedInstance.getCurrentGame().currentTurn) wins!")
            }
            if OXGameController.sharedInstance.getCurrentGame().state() ==  OXGameState.Tie {
                print("It's a tie!")
            }
            // make buttons unclickable
            for subview in containerView.subviews {
                if let button = subview as? UIButton {
                    button.enabled = false
                }
            }
        }
    }
    
    func restartGame() {
        OXGameController.sharedInstance.restartGame()
        
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

