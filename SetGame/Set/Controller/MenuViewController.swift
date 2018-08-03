//
//  MenuViewController.swift
//  SetGame
//
//  Created by Felipe Montoya on 2/8/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    
    enum UserRequestedAction {
        case newGame, playVsPc, help, dealCards, none
    }
    
    private var _actionRequested: UserRequestedAction?
    
    
    /**
     An action requested by the user
     */
    var actionRequested: UserRequestedAction  {
        return _actionRequested != nil ? _actionRequested! : .none
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - @IBAction
    
    @IBAction func hooverOverButton(sender: UIButton) {
    sender.isHighlighted = true
    }
    
    
    @IBAction func newGameButtonPressed(sender: UIButton) {
        _actionRequested = .newGame
        unwindButtonPressed(sender: sender)
        sender.isHighlighted = false
    }
    
    @IBAction func playVsPcButtonPressed(sender: UIButton) {
        _actionRequested = .playVsPc
        unwindButtonPressed(sender: sender)
        sender.isHighlighted = false
    }
    
    @IBAction func helpMeButtonPressed(sender: UIButton) {
        _actionRequested = .help
        unwindButtonPressed(sender: sender)
        sender.isHighlighted = false
    }
    
    @IBAction func deal3MoreCardsButtonPressed(sender: Any) {
        _actionRequested = .dealCards
        unwindButtonPressed(sender: sender)
    }
    
    
    // MARK: - Navigation
 
    
    @IBAction func unwindButtonPressed(sender: Any) {
        performSegue(withIdentifier: "unwindToMainVC", sender: nil)
    }
    
    

}
