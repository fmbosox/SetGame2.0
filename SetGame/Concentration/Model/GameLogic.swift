//
//  ConcentrationGameLogic.swift
//  ConcentrationGame
//
//  Created by Felipe Montoya on 1/25/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import Foundation





class GameLogic {
    
    
    
    func startGame () -> Date {
        print("The game is live now")
        return Date()
    }
    
    func play(card: ConcentrationCard,and cardTwo: ConcentrationCard) -> (Int, Bool) {
        var points = 0
        let match = (card.emoji == cardTwo.emoji )
        
        points += card.cardHasBeenCompared ? -1 : 0 // Only in a missMatch
        points  += cardTwo.cardHasBeenCompared ? -1: 0
        points += match ? 4 : 0

        return (points, match)
        }
    
    func pointsMultiplier ( timeInterval: DateInterval) -> Int {
        if timeInterval.duration < 10.0 {
            return 10
        } else if timeInterval.duration < 70.0 {
             return 5
        } else {
            return 1
        }
    }
    


}


