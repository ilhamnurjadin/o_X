//
//  BoardViewController.swift
//  o_X
//

import UIKit

class BoardViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func newGameButtonPressed(sender: UIButton) {
        print("New game button pressed.")
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        print("Logout button pressed")
    }
    
    @IBAction func boxButtonPressed(sender: AnyObject) {
        let buttonTag = sender.tag!
        print("Button \(buttonTag) was pressed hi!")
    }

}

