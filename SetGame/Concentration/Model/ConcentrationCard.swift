//
//  Card.swift
//  ConcentrationGame
//
//  Created by Felipe Montoya on 1/25/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import Foundation


struct ConcentrationCard {
     var emoji: String
     var cardHasBeenCompared: Bool
     var isShowingEmoji: Bool
    
    init(with emoji: String) {
        self.emoji = emoji
        cardHasBeenCompared = false
        isShowingEmoji = false
    }
}
