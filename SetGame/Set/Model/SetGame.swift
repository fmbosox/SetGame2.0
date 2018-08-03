
//  Created by Felipe Montoya on 2/3/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.

import Foundation

enum GameError: Error {
    case couldntGenerateADeck , couldntPerformValidation, couldntGenerateACard
}

/**
 An actual Set Game Logic independent of the UI.
 
 */
class SetGame {
    
// MARK: Properties
    /**
     The current deck in the game, where you can spawn more cards.
     */
    private var deck: Set<Card>
    
    /**
     The date/time when the users starts to find a new set.
     */
    private var beginTimer: Date!
    
    
    /**
     The points multiplier.
     */
    private var pointsMultiplier: Int {
        let currentTime = Date()
        let timeInterval: TimeInterval = DateInterval(start: beginTimer, end: currentTime).duration
        switch timeInterval {
        case 0...20.00: return 10
        case 20.01...30.0: return 2
        default: return 1
        }
    }
    
    
   /**
     The current score of the player.
    */
     var score: Int

    
    
    /**
     A helper function to generateTheCardNeededForASet, that perform some bitwise logic for a property of Card.
     */
    private func getComplementaryBits( between characteristicOne: Int, and characteristicTwo: Int) -> Int{
        let cOne = UInt8(characteristicOne )
        let cTwo = UInt8(characteristicTwo )
        let bits: UInt8 = (cOne == cTwo) ? cOne : (~(cOne ^ cTwo) << 5) >> 5
        return Int(bits)
    }
    
    /**
     A function  that returns the ideal card for a Set to be true.
     */
    func generateTheCardNeededForASet(with cardOne: Card,and cardTwo: Card)throws -> Card {
        let colorBits = getComplementaryBits(between: cardOne.color.rawValue, and: cardTwo.color.rawValue)
        let numberBits = getComplementaryBits(between: cardOne.number.rawValue, and: cardTwo.number.rawValue)
        let symbolBits = getComplementaryBits(between: cardOne.symbol.rawValue, and: cardTwo.symbol.rawValue)
        let shadingBits = getComplementaryBits(between: cardOne.shading.rawValue, and: cardTwo.shading.rawValue)
        
        let color = CardColor(rawValue: colorBits)
        let number = CardNumber(rawValue: numberBits )
        let symbol = CardSymbol(rawValue: symbolBits)
        let shading = CardShading(rawValue: shadingBits )
        guard let cardNumber = number, let cardSymbol = symbol, let cardShading = shading, let cardColor = color else { throw GameError.couldntGenerateACard }
        let cardThree = Card (number: cardNumber, symbol: cardSymbol, shading: cardShading, color: cardColor)
        return cardThree
    }
    
    
    init() {
        self.deck = []
        self.score = 0
    }
    
// MARK: Game Logic
    
    /**
     Starts by generating and shuffling a new deck of cards and start the timer
     */
    func start () {
        do{
            cardColorLoop: for powerIndex in 0..<3 {
                let cardColor = CardColor(rawValue: 0b001 << powerIndex)
                cardShadingLoop: for powerIndex in 0..<3 {
                    let cardShading = CardShading(rawValue: 0b001 << powerIndex)
                    cardSymbolLoop: for powerIndex in 0..<3 {
                        let cardSymbol = CardSymbol(rawValue: 0b001 << powerIndex)
                        cardFinalLoop: for powerIndex in 0..<3 {
                            let number = CardNumber(rawValue: 0b001 << powerIndex)
                            guard let cardNumber = number, let cardSymbol = cardSymbol, let cardShading = cardShading, let cardColor = cardColor else { throw GameError.couldntGenerateADeck }
                                let aSetGameCard = Card (number: cardNumber, symbol: cardSymbol, shading: cardShading, color: cardColor)
                                self.deck.insert(aSetGameCard)
                        }
                    }
                }
            }
        } catch {
            print(" Couldnt generate a Deck")
            fatalError()
        }
        beginTimer = Date()
    }
    
    /**
     Deals by default 3 cards to the user as requested until the deck runs out of cards
     
     # How many cards do you want?
     */
    func dealCards(_ cardsToDeal: Int = 3) -> Set<Card>? {
        var cards: Set<Card> = []
        var cardsCounter = 0
        guard !self.deck.isEmpty else { return nil }
        repeat{
            let aCard = self.deck.removeFirst()
            cards.insert(aCard)
            cardsCounter += 1
        }while(!self.deck.isEmpty && cardsCounter < cardsToDeal)
        return cards
    }
    
    
    
    /**
     Validates if three cards can be matched as a SET in accordance with the official GameRules.

     - parameters:
        - set: A proposed Set
     */
    private func validateAProposedSet(with set: [Card]) -> Bool {
        do{
           return try generateTheCardNeededForASet(with: set[0], and: set[1]) == set[2]
        } catch {
            print("Couldn't perform validation")
            return false
        }
    }
    
    /**
     Make a play with a given Set
     */
    func makeAPlay(with cardOne:Card, cardTwo: Card, and cardThree: Card) -> (resultOfPlay: Bool, updatedScore: Int) {
            let validationResult = validateAProposedSet(with: [cardOne,cardTwo,cardThree])
            let points = validationResult ? 5 * pointsMultiplier : -2 * pointsMultiplier
            self.score = points
             beginTimer = Date()
            return (validationResult, score)
    }
    
    
    /**
     Starts a brand new game! Enjoy!
     */
    func reset() {
        self.deck = []
        self.score = 0
        start()
    }
    
    
    
    
}
