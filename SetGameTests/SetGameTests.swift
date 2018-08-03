//
//  SetGameTests.swift
//  SetGameTests
//
//  Created by Felipe Montoya on 2/3/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import XCTest
@testable import SetGame

class SetGameTests: XCTestCase {
    
    let game = SetGame ()
    override func setUp() {
        super.setUp()
    }
    
    func test_GameStartsCorrctly() {
        game.start()
    }
    
    func test_IfDealsCardsCorrectly() {
        game.start()
        let setOfCards = game.dealCards(12)
        XCTAssertNotNil(setOfCards)
        XCTAssertNotNil(game.dealCards(80))
        XCTAssertNil(game.dealCards())
    }
    
    func test_IfYouCanPlayWith() {
        game.start()
        let setOfCards = game.dealCards(12)
        for aCard in setOfCards! {
             let a = game.makeAPlay(with: aCard)
            print(a.debugDescription)
        }
       
    }
    
    
    func test_IfYouCanMakeAMatch() {
        game.start()
        
        let cardOne = Card (number: .one, symbol: .diamond, shading: .open, color: .green)
        let cardTwo = Card (number: .one, symbol: .oval, shading: .solid, color: .green)
        let cardThree = Card (number: .three, symbol: .oval, shading: .solid, color: .green)
        let cardFour = Card (number: .one, symbol: .squiggle, shading: .stripped, color: .green)
        
        var result = game.makeAPlay(with: cardOne)
        result = game.makeAPlay(with: cardTwo)
        result = game.makeAPlay(with: cardThree)
        
        XCTAssertFalse(result!.resultOfPlay )
        
        result = game.makeAPlay(with: cardThree)
        result = game.makeAPlay(with: cardFour)
        
        XCTAssert(result!.resultOfPlay)
        
        result = game.makeAPlay(with: cardThree)
        
    }
    
    func test_IfYouCanResetTheGame() {
        game.start()
        let setOfCards = game.dealCards(12)
        for aCard in setOfCards! {
            _ = game.makeAPlay(with: aCard)
        }
        print(game.score)
        game.reset()
        print("Reset New score:\(game.score)")
        
        
    }
    
    
}
