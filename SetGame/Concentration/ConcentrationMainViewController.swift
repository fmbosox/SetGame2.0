//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Felipe Montoya on 1/25/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class ConcentrationMainViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardsButtons: [UIButton]!
    
    var game = ConcentrationGame ()
    var buttonColor = UIColor()
    
    var theme: GameTheme?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func updateView () {
        for index in game.winnerCombination{
            cardsButtons[index].isEnabled = false
            cardsButtons[index].backgroundColor = #colorLiteral(red: 0.4520513415, green: 1, blue: 0.2541933656, alpha: 0.5)
        }
    }
    

    func setColors () {
        switch game.theme {
        case .animals: self.view.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        buttonColor = #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)
        case .food: self.view.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        buttonColor = #colorLiteral(red: 0.7079763412, green: 1, blue: 0.9136965871, alpha: 1)
        case.halloween: self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        buttonColor = #colorLiteral(red: 1, green: 0.5275941491, blue: 0.227538228, alpha: 1)
        case.profesions: self.view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        buttonColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        case.sports: self.view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        buttonColor = #colorLiteral(red: 1, green: 0.760229826, blue: 0.8062340617, alpha: 1)
        case.winter: self.view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        buttonColor = #colorLiteral(red: 0, green: 0.09690500051, blue: 1, alpha: 1)
        }
    }
    
    func beginUpdates () {
        game.setGame(with: theme)
        setColors()
        for aButton in cardsButtons {
            aButton.isEnabled = true
            aButton.setTitle("", for: .normal)
            aButton.backgroundColor = buttonColor
        }
        scoreLabel.text = String(game.points)
      
    }
   
    
    @IBAction func aCardButtonPressed(_ sender: UIButton) {
        let currentIndex = cardsButtons.index(of: sender)!
        game.flipCardAt(currentIndex)
        let aCard = game.cards [currentIndex]
        if aCard.isShowingEmoji {
            UIView.transition(with: sender, duration: 0.25, options: [.transitionFlipFromRight], animations: {
                sender.setTitle(aCard.emoji, for: .normal)
                sender.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            })
        } else {
            if sender.titleLabel?.text == "" ||  sender.titleLabel?.text == nil {
                sender.backgroundColor = self.buttonColor
            } else {
                UIView.transition(with: sender, duration: 0.25, options: [.transitionFlipFromRight], animations: {
                    sender.setTitle("", for: .normal)
                    sender.backgroundColor = self.buttonColor
                })
            }
        
        
        }
        scoreLabel.text = String(game.points)
        updateView()
    }
    
    @IBAction func newGameButtonPressed(_ sender: Any) {
        game.reset()
        beginUpdates()
    }
    
    
}

