//
//  ViewController.swift
//  SetGame
//
//  Created by Felipe Montoya on 2/3/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//
enum UIError: Error {
    case couldntDrawCard, couldntLoadCardToGameLogic , cantHelp , setNotAvailable
}

import UIKit


class MainViewController: UIViewController {
    
    
    @IBOutlet weak var deckView: UIView! {
        didSet {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapForCardsRecognizer))
            deckView.addGestureRecognizer(tapRecognizer)
        }
        
    }
    @IBOutlet weak var pcEmoji: UILabel!
    @IBOutlet weak var pcScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gridHolderView: GridHolderView! {
        didSet {
            let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGesture(recognizer: )))
            gridHolderView.addGestureRecognizer(swipeRecognizer)
            
            let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotation(recognizer: )))
            gridHolderView.addGestureRecognizer(rotationRecognizer)
            
            
        }
        
        
    }
    
    
    var cardsInUI = [Card]()
    var selectedCards: Set <Card> = []
   
    
    
    private var pcScore = 0
    private var userScore = 0
    
    /**
     The game logic that is currently played
     */
    private let game = SetGame()
    
    


    private lazy var userPlaying = false
   

    
     //MARK: METHODS
    
    @objc func tapForCardsRecognizer() {
        updateUIwith(requestedCards: 3)
    }
    
    @objc func swipeDownGesture(recognizer: UISwipeGestureRecognizer) {
        switch recognizer.state {
        case .ended :
            let direction =  recognizer.direction
            if direction == UISwipeGestureRecognizerDirection.down || direction == UISwipeGestureRecognizerDirection.right {
                 print("swipe down ninja!!!")
                updateUIwith(requestedCards: 3)
            }
        default: break
            
        }
        
    }
    
    
    @objc func rotation(recognizer: UIRotationGestureRecognizer) {
        
        switch recognizer.state {
        case .ended :
            let rotation = recognizer.rotation
            if rotation  > CGFloat.pi/4 ||  rotation  < CGFloat.pi/4{
                print("Rotation wuju!!!")
                shuffleCardsInUI()
            }
        default: break
            
        }
    }

    private func pcMove() {
      let PCLevel = arc4random_uniform(20)
        if PCLevel < 5 {
            let set = findASet(PC: true)
            if set.isEmpty {
                 pcEmoji.text = "😌"
            } else {
                 pcEmoji.text = "🤪"
                selectedCards = set
                playGame(PC: true)
            }
        } else {
            for _ in 0...(PCLevel) {
                let set = findASet(PC: true)
                if set.isEmpty {
                    pcEmoji.text = "😌"
                } else {
                    selectedCards = set
                    playGame(PC: true)
                     pcEmoji.text = "😉"
                    break
                }
            }
        }
    }
        
    
     private var PCFiringTimer: (timerOne: Timer?, timerTwo:Timer?)
   private func playVsPcMode() {
        pcScoreLabel.isHidden = false
        startNewGame()
        pcEmoji.text = "🤖"
    PCFiringTimer.timerOne = Timer.scheduledTimer(withTimeInterval: 13.00, repeats: true, block: { (timer) in
            if !self.userPlaying {
                self.pcMove()
            }else {
                self.pcEmoji.text =  self.pcScore > self.userScore ? "haha😂" : "🧐"
            }
        })
       PCFiringTimer.timerTwo = Timer.scheduledTimer(withTimeInterval: 10.00, repeats: true, block: { (timer) in
            self.userPlaying = !self.userPlaying
        })
    }
    
    
    
    /**
     Helps to find a set.
     */
    private func findASet(PC pcMove: Bool = false) -> Set<Card> {
      
        self.gridHolderView.setNeedsLayout()
        func generateASet() -> Set<Card>? {
            
            let cardsAvailableInUI = cardsInUI.filter { (card) -> Bool in
               let cardViewFromCard = PlayingCardView ()
                cardViewFromCard.color = card.color.stringColor; cardViewFromCard.shading = card.shading.stringShading
                cardViewFromCard.number = card.number.number; cardViewFromCard.symbol = card.symbol.stringSymbol
                
                return !cardViewFromCard.isMemberOf(self.gridHolderView.cardViewsInASet)

            }
            let randomCardOne = cardsAvailableInUI[Int(arc4random_uniform(UInt32(cardsAvailableInUI.count)))]
            var randomCardTwo: Card
            repeat {
                randomCardTwo = cardsAvailableInUI[Int(arc4random_uniform(UInt32(cardsAvailableInUI.count)))]
            }while (randomCardOne == randomCardTwo)
            do {
                let cardNeeded = try game.generateTheCardNeededForASet(with: randomCardOne, and: randomCardTwo)
                if cardsAvailableInUI.contains(cardNeeded){
                    return [cardNeeded, randomCardTwo, randomCardOne]
                } else {
                    return nil
                }
                
            } catch {
                print("Error")
                return nil
            }
        }
        
        var i: Int = 0
        var x: Int = pcMove ? 6 : 0
        repeat {

            if i == 25 {
                i = 1
                updateUIwith(requestedCards: 3)
                x += 1
            }
            i += 1
            guard let set = generateASet() else { continue }
                return set
        }while (x != 6)
        return []
        
    }
    
    /**
     Helps a player to find a Set.
     */
    func helpThePlayer() {
        selectedCards = findASet()
        playGame()
    }
    
    
    func shuffleCardsInUI() {
        self.gridHolderView.subviews.forEach( { $0.removeFromSuperview() })
        self.gridHolderView.playingCardsInUI.removeAll()
        cardsInUI = cardsInUI.sorted(by: { (cardOne, cardTwo) -> Bool in
            let sortBy = arc4random_uniform(4)
            
            switch sortBy {
            case 1 : return cardOne.symbol.hashValue > cardTwo.shading.hashValue
            case 2 : return cardOne.color.hashValue > cardTwo.shading.hashValue
            case 3 : return cardOne.shading.hashValue > cardTwo.number.hashValue
            default :
                return cardOne.color.hashValue > cardTwo.color.hashValue
            }
            
            
            
            
        })
        for card in cardsInUI {
            let cardView = PlayingCardView()
            cardView.color = card.color.stringColor
            cardView.number = card.number.number
            cardView.shading = card.shading.stringShading
            cardView.symbol = card.symbol.stringSymbol
            self.gridHolderView.playingCardsInUI.append(cardView)
            selectedCards.removeAll()
        }
        self.gridHolderView.setNeedsLayout()
    
    }
    
    
    /**
     If there are
     sufficient cards on the deck it will add cards to the UI.
     */
     func updateUIwith (requestedCards: Int ) {
        let givenCards = game.dealCards(requestedCards)
        if let givenCards = givenCards {
            for card in givenCards {
                cardsInUI.append(card)
                let cardView = PlayingCardView()
                cardView.color = card.color.stringColor
                cardView.number = card.number.number
                cardView.shading = card.shading.stringShading
                cardView.symbol = card.symbol.stringSymbol
                self.gridHolderView.playingCardsInUI.append(cardView)
                selectedCards.removeAll()
            }
            self.gridHolderView.setNeedsLayout()
        }
    }
    
    
    /**
     It plays the game,disable those cards that match. Updates the score.
     */
    private func playGame (PC pcMove: Bool = false) {
       //If there are three cardSelected check for a Set, updateScore.
        if selectedCards.count == 3 {
            let cardOne = selectedCards[selectedCards.startIndex]
            let cardTwo = selectedCards[selectedCards.index(selectedCards.startIndex, offsetBy: 1)]
            let cardThree = selectedCards[selectedCards.index(selectedCards.startIndex, offsetBy: 2)]
            let play = game.makeAPlay(with: cardOne, cardTwo: cardTwo, and: cardThree)
            
            if play.resultOfPlay  {
                for card in selectedCards {
                    let cardView = PlayingCardView() //if theres is a match do not allow more interactions in those card as long as they remain in the GridView
                    cardView.color = card.color.stringColor
                    cardView.number = card.number.number
                    cardView.shading = card.shading.stringShading
                    cardView.symbol = card.symbol.stringSymbol
                    self.gridHolderView.cardViewsInASet.insert(cardView)
                }
                selectedCards.removeAll()
                updateUIwith(requestedCards: 3)
            }
            
            if !pcMove {
                userScore += play.updatedScore
                scoreLabel.text = "Score: \(userScore)"
            } else {
                pcScore += play.updatedScore
                pcScoreLabel.text = "PC: \(pcScore)"
            }
        }
        
    }

    
    /**
     Starts a new game, enjoy!
     */
    private func startNewGame() {
        game.reset()
        gridHolderView.resetViews()
        cardsInUI.removeAll()
        pcScoreLabel.isHidden = true
        pcEmoji.text = "1P"
        scoreLabel.text = "NEW GAME"
        pcScore = 00
        userScore = 00
        selectedCards.removeAll()
        PCFiringTimer.timerOne?.invalidate()
        PCFiringTimer.timerTwo?.invalidate()
        updateUIwith(requestedCards:12)
    }
    
    
    //MARK: NAVIGATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.start()
        updateUIwith(requestedCards:12)
        
    }
    
    /**
     When returning will check the action requested to call the proper method.
     */
    @IBAction func unwindToMainViewController (segue: UIStoryboardSegue) {
        ///
        let menuViewController = segue.source as! MenuViewController
        switch (menuViewController.actionRequested) {
            
        case .newGame: startNewGame()
        case .playVsPc:  playVsPcMode()
        case .help:
            helpThePlayer()
        case .dealCards: updateUIwith(requestedCards: 3)
        case .none:
            return
        }
     
    }
    
        //MARK: @IBAction
    
  
    @IBAction func menuButtonPressed(_ sender: Any) {
        //Show Menu options
    }
    
    
    
    
    
}



extension MainViewController: PlayingCardViewDelegate {
    

    func didSelectedACard(_ cardView: PlayingCardView) {
        //if this is a 4 card, deselect every otherCard and just select this one.
        if selectedCards.count  == 3 {
            for view in gridHolderView.subviews {
                guard let selectedCardView = view as? PlayingCardView else { continue }
                    if selectedCardView.isASelectedCard {
                        let possibleSelectedCard = getCardFrom(color: selectedCardView.color, symbol: selectedCardView.symbol, shading: selectedCardView.shading, number: selectedCardView.number)
                        guard let selectedCard = possibleSelectedCard else { continue }
                            if selectedCards.contains(selectedCard) {
                                selectedCardView.selectOrdeselectCard() //remove it from view and selectedCards
                            } else {
                                selectedCards.insert(selectedCard)
                            }
                    }
            }
        } else {
                let possibleCard = getCardFrom(color: cardView.color, symbol: cardView.symbol, shading: cardView.shading, number: cardView.number)
                guard let card = possibleCard else { return }
                selectedCards.insert(card)
        }
        playGame()
    }
    
    func didDeselectedACard(_ cardView: PlayingCardView) {
        let possibleCard = getCardFrom(color: cardView.color, symbol: cardView.symbol, shading: cardView.shading, number: cardView.number)
        guard let card = possibleCard else { return }
            selectedCards.remove(card)
    }
    
    
}


