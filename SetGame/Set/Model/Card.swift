//  Copyright © 2018 Felipe Montoya. All rights reserved.

import Foundation


func getCardNumberFrom(integer: Int) -> CardNumber? {
    switch integer {
        case 1 :
            return CardNumber.one
        case 2:
            return CardNumber.two
        case 3 :
            return CardNumber.three
        default: return nil
    }
}


/**
 A CardNumber type has only three options represented by bits.
 - one: 0b001
 - two: 0b010
 - three: 0b100
 */
enum CardNumber: Int {
    case one = 0b001, two = 0b010,  three = 0b100
    
    
    var number: Int {
        switch self {
            case .one:
                return 1
            case .two:
                return 2
            case .three:
                return 3
        }
    }
}


func getCardSymbolFrom(string: String) -> CardSymbol? {
 
    switch string {
    case "diamond":
        return CardSymbol.diamond
    case "squiggle":
        return CardSymbol.squiggle
    case "oval":
        return CardSymbol.oval
    default: return nil
    }
    
}

/**
 A CardSymbol type has only three options represented by bits.
 - diamond: 0b001
 - squiggle: 0b010
 - oval: 0b100
 */
enum CardSymbol: Int {
    case  diamond = 0b001, squiggle = 0b010, oval = 0b100
    
    
    var stringSymbol: String {
        switch self {
        case .diamond:
           return "diamond"
        case .squiggle:
            return "squiggle"
        case .oval:
            return "oval"
        }
    }
    
    
}


func getCardShadingFrom(string: String) -> CardShading? {
    switch string {
    case "solid":
        return CardShading.solid
    case "stripped":
       return CardShading.stripped
    case "open":
        return CardShading.open
    default: return nil
    }
    
}



/**
 A CardShading type has only three options represented by bits.
 - solid: 0b001
 - stripped: 0b010
 - open: 0b100
 */
enum CardShading: Int {
    case solid = 0b001, stripped = 0b010,  open = 0b100
    
    
    var stringShading: String {
        switch self {
            case .solid:
                return "solid"
            case .stripped:
               return "stripped"
            case .open:
                return "open"
        }
        
        
    }
    
}




func getCardColorFrom(string: String) -> CardColor? {
    switch string {
    case "red":
        return CardColor.red
    case "green":
        return CardColor.green
    case "purple":
        return CardColor.purple
    default: return nil
    }
}
/**
 A CardColor type has only three options represented by bits.
 - red: 0b001
 - green: 0b010
 - purple: 0b100
 */
enum CardColor: Int {
    case  red = 0b001, green = 0b010, purple = 0b100
    
    
    var stringColor: String {
        
        switch self{
            case .red:
                return "red"
            case .green:
               return "green"
            case .purple:
                return "purple"
        }
    
    }
    
}


func getCardFrom (color: String, symbol: String, shading: String, number: Int) -> Card? {
    let possibleColor = getCardColorFrom(string: color )
    let possibleSymbol = getCardSymbolFrom(string: symbol)
    let possibleShading = getCardShadingFrom(string: shading )
    let possibleNumber = getCardNumberFrom(integer: number)
    
    guard let aColor = possibleColor, let aSymbol = possibleSymbol, let aShade = possibleShading, let aNumber = possibleNumber else { return nil }
    return Card(number: aNumber, symbol: aSymbol, shading: aShade, color: aColor)
}




/**
 A Card Object. It is used to play a Set Game.
 
 -Parameters:
    - number: the number of figueres in card.
    - symbol: the type of the figuere.
    - shading: the shading of the figueres
    - color: the color of the figures.
 */

struct Card {
    let number: CardNumber
    let symbol: CardSymbol
    let shading: CardShading
    let color: CardColor
}

extension Card: Hashable{
    var hashValue: Int {
        return (color.rawValue << 9) + (shading.rawValue << 6) +  (symbol.rawValue << 3) + (number.rawValue) 
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
       return lhs.hashValue == rhs.hashValue
    }
}

//21
