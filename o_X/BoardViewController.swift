//
//  BoardViewController.swift
//  o_X
//

import UIKit

class BoardViewController: UIViewController {
    
    // Subviews
    @IBOutlet weak var newGameButton: UIButton?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var refreshBarButton: UIBarButtonItem!
    @IBOutlet weak var messageLabel: UILabel!
    
    // Variables
    var networkMode: Bool = false
    
    // New
    //var gameObject = OXGame()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if !networkMode {
            statusLabel.text = OXGameController.sharedInstance.getStateInString(networkMode)
        }
        
        updateUI()
        
        // If network mode is true, then check if host has connected
        if networkMode {
            OXGameController.sharedInstance.refreshGame { game, bool, message in
                
                /*
                if let myBool = bool {
                    if !myBool {
                        self.disableAllButtons()
                        self.statusLabel.text = ""
                        self.messageLabel.text = "Awaiting for Opponent to Join..."
                    }
                }
                 */
                
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func newGameButtonPressed(sender: UIButton) {
        
        print("New game button pressed.")
        restartGame()
        
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        
        print("Logout button pressed")
        
        restartGame()
        
        UserController.sharedInstance.logout { (errorMessage: String?) in
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.presentViewController(vc!, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func boxButtonPressed(sender: UIButton) {
        
        let buttonTag = sender.tag
        print("Button \(buttonTag) was pressed!")
        
        let temp:String = OXGameController.sharedInstance.playMove(buttonTag).rawValue
        
        sender.setTitle(temp, forState: .Normal)
        
        if networkMode {
            
            // Serialize board, send to server, and deserialize updated board
            OXGameController.sharedInstance.playMove { game, message in
                if game != nil {
                    print("success")
                }
                else {
                    self.createAlert("Could Not Play Move", submessage: message!, onDismiss: { action in })
                }
            }
        }
        
        updateUI()
    }
    
    @IBAction func exitGameBarButtonPressed(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
        OXGameController.sharedInstance.restartGame()
        networkMode = false
    }
    
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        
        OXGameController.sharedInstance.refreshGame { game, bool, message in
            if game != nil {
                // refresh successful and board was re-deserialized
                self.updateUI()
                self.checkIfGameEnded()
            }
            else {
                self.createAlert("Board could not be refreshed", submessage: message!, onDismiss: { action in})
            }
            
            /*
            if let myBool = bool {
                if !myBool {
                    self.disableAllButtons()
                    self.statusLabel.text = ""
                    self.messageLabel.text = "Awaiting for Opponent to Join..."
                }
            }
             */
            
        }
    }
    
    func checkIfGameEnded() {
        // Checking for game state - determining if game is over
        // This is still printed if game is over
        if OXGameController.sharedInstance.getCurrentGame().state() != OXGameState.InProgress {
            
            self.statusLabel.text = ""
            
            createAlert("Game Over", submessage: OXGameController.sharedInstance.getStateInString(networkMode)) { action in }
            
            disableAllButtons()
            
            if networkMode {
                refreshBarButton.enabled = false
            }
        }
    }
        
    func restartGame() {
        OXGameController.sharedInstance.restartGame()
        statusLabel.text = OXGameController.sharedInstance.getStateInString(networkMode)
        
        for subview in containerView.subviews {
            if let button = subview as? UIButton {
                // change title of buttons
                button.setTitle("", forState: .Normal)
                // make buttons clickable
                button.enabled = true
            }
        }
    }
    
    /*
     * BoardViewController's updateUI() function
     * Although we haven't completed full network functionality yet,
     * this function will come in handy when we have to display our opponents moves
     * that we obtain from the networking layers (more on that later)
     * For now, you are required to implement this function in connection with Activity 1 from todays class
     * Hint number 1: This function must set the values of O and X on the board, based on the games board array values. Does this kind of remind you of the resetBoard or newGameTapped function???
     * Hint number 2: if you set your board array to private in the OXGame class, maybe you should set it now to 'not private' ;)
     * Hint number 3: call this function in BoardViewController's viewDidLoad function to see it execute what board was set in the game's initialiser on your screen!
     * And Go!
     */
    func updateUI() {
        
        statusLabel.text = OXGameController.sharedInstance.getStateInString(networkMode)
        
        // Makes buttons that are not empty unclickable, and buttons that are empty clickable
        for subview in containerView.subviews {
            if let button = subview as? UIButton {
                if OXGameController.sharedInstance.getCurrentGame().board[button.tag] != CellType.Empty {
                    button.setTitle(OXGameController.sharedInstance.getCurrentGame().board[button.tag].rawValue, forState: .Normal)
                    // make buttons clickable
                    button.enabled = false
                }
                else {
                    button.enabled = true
                }
            }
        }
        
        // Make all buttons unclickable when not your turn
        if networkMode {
            
            self.title = "Game ID: \(OXGameController.sharedInstance.getCurrentGame().ID)"
            
            if OXGameController.sharedInstance.amIHost() {
                if OXGameController.sharedInstance.getCurrentGame().turnCount() % 2 == 1 {
                    disableAllButtons()
                }
            }
            else {
                if OXGameController.sharedInstance.getCurrentGame().turnCount() % 2 == 0 {
                    disableAllButtons()
                }
            }
        }
        
        checkIfGameEnded()
        
    }
    
    func disableAllButtons() {
        
        for subview in containerView.subviews {
            if let button = subview as? UIButton {
                // make buttons unclickable
                button.enabled = false
            }
        }
    }

}

