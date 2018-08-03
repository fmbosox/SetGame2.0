//
//  ConcentrationGame.swift
//  ConcentrationGame
//
//  Created by Felipe Montoya on 1/25/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import Foundation


func getThemeFor(string: String) -> GameTheme? {
    switch string {
        case "Winter": return .winter
        case "Halloween": return .halloween
        case "Animals": return .animals
        case "Profesions": return .profesions
        case "Sports": return .sports
        case "Food" : return .food
    default: return nil
    }
    
}

enum GameTheme: Int {
    case winter = 0 , halloween, animals, profesions, sports, food
    
    
  
}

enum GameState {
    case noCardsAtPlay, waitingForAnotherCard, readyToCompareCards
}

class ConcentrationGame {
    
    private  let emojis: [GameTheme: [String]] = [.winter: ["☃️","❄️","🌥","🧤","🧣","🎅🏻"],
                                                  .halloween: ["🎃","👻","🤡","🧟‍♂️","💀","🧛‍♂️"],
                                                  .animals: ["🐶","🐱","🐷","🐼","🐯","🦁"],
                                                  .profesions: ["👩‍✈️","👩‍🔧","👨‍🏫","👨‍🌾","👨‍💻","👩‍🎤"],
                                                  .sports: ["🏋️‍♀️","🤽‍♀️","🤸‍♀️","⛹️‍♂️","🧘‍♂️","🥇"],
                                                  .food: ["🍎","🍊","🍉","🍪","🍕","🌮"]]
    private var _theme: GameTheme!
    private var _cards: [ConcentrationCard] = []
    private lazy var gameLogic = GameLogic()
    private var _gameStarted = false
    private var _gameInit_time: Date!
    private  var _points: Int = 0
    private var olderIndex: Int? = nil
    private var _winnerCombination = [Int]()
   
    
    private var playedCardsIndeces: (Int?,Int?)
    private var gameState = GameState.noCardsAtPlay
    
    var winnerCombination: [Int] {
        return _winnerCombination
    }
    
    var theme: GameTheme {
        return _theme
    }
   
    var cards: [ConcentrationCard] {
        return _cards
    }
    
    var points: Int {
        return _points
    }
    
    
    
    
    private func shuffle(_ cards: [ConcentrationCard]){
        for index in cards.indices{
            let randomIndex = Int(arc4random_uniform(11))
            _cards.swapAt(index, randomIndex)
        }
    }
    
    private func addMultiplier(to points: Int) -> Int {
        return points * gameLogic.pointsMultiplier(timeInterval: DateInterval(start: _gameInit_time, end: Date()))
    }
    
    func reset() {
        _cards.removeAll()
        _gameStarted = false
        _points = 0
        _winnerCombination = [Int]()
        gameState = .noCardsAtPlay
        playedCardsIndeces = (nil, nil)
    }
    
    
    func setGame (with theme: GameTheme? = nil) {
        let aTheme = theme ?? GameTheme(rawValue: Int(arc4random_uniform(5)))
        guard let theme = aTheme else{ fatalError() }
            let emojis = self.emojis[theme]!
            for aEmoji in emojis {
                _cards.append(ConcentrationCard(with: aEmoji))
                _cards.append(ConcentrationCard(with: aEmoji))
            }
            if _cards.count != 12 {
                fatalError()
            }
            shuffle(_cards)
            _theme = theme
    }
    
  private  func checkForAMatchBetween(_ cardOne: ConcentrationCard,_ cardTwo: ConcentrationCard ) -> Bool{
            let a: (score: Int, match: Bool) = gameLogic.play(card: cardOne, and: cardTwo)
            if a.match {
                _points += addMultiplier (to: a.score)
                return true
            } else {
                _points += a.score
                return false
            }
        }

    ///check flipACard it can be donde much better.
    
    func  updateGameState(withControlState controlState: Bool, andIndex currentIndexSelected: Int) {
        
        if controlState {
            switch gameState {
            case .noCardsAtPlay:
                gameState = .waitingForAnotherCard
                playedCardsIndeces.0 = currentIndexSelected
            case .waitingForAnotherCard:
                gameState = .readyToCompareCards
                playedCardsIndeces.1 = currentIndexSelected
                
                let aMatch = checkForAMatchBetween(_cards[playedCardsIndeces.0!], _cards[playedCardsIndeces.1!])
                if  aMatch {
                    gameState = .noCardsAtPlay
                    _winnerCombination = [playedCardsIndeces.0!, playedCardsIndeces.1!]
                }
                _cards[playedCardsIndeces.0!].cardHasBeenCompared = true
                _cards[playedCardsIndeces.1!].cardHasBeenCompared = true
                playedCardsIndeces = aMatch ? (nil,nil) : playedCardsIndeces
            case .readyToCompareCards:
                _cards[currentIndexSelected].isShowingEmoji = false
            }
        } else {
            switch gameState {
            case .readyToCompareCards:
                gameState = .waitingForAnotherCard
                playedCardsIndeces.0 = playedCardsIndeces.0! == currentIndexSelected ? playedCardsIndeces.1 : playedCardsIndeces.0
                playedCardsIndeces.1 = nil
                
            case .waitingForAnotherCard:
                gameState = .noCardsAtPlay
                playedCardsIndeces = (nil, nil)
                
            case .noCardsAtPlay: break
            }
        }
        
    }
    
    func flipCardAt(_ currentIndexSelected: Int)  {
        if  _gameStarted == false {
            _gameInit_time = gameLogic.startGame()
            _gameStarted = true
        }
         _cards[currentIndexSelected].isShowingEmoji = !_cards[currentIndexSelected].isShowingEmoji
        updateGameState(withControlState: _cards[currentIndexSelected].isShowingEmoji, andIndex: currentIndexSelected)
    }
    


}

