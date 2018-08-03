//
//  GridHolderView.swift
//  SetGame
//
//  Created by Felipe Montoya on 2/22/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class GridHolderView: UIView {
    
    
    struct AnimationKeys {
        static let defaultDuration = 0.8
        static let defaultDelay = 0.3
    }

    var playingCardsInUI: [PlayingCardView] = []
    var cardViewsInASet: Set <PlayingCardView> = [] {
        didSet {
                if cardViewsInASet.count % 3 == 0 {
                    animate()
                    setNeedsLayout()
                }
        }
        
    }
    
    
    var grid: Grid = Grid(layout: Grid.Layout.dimensions(rowCount: 1, columnCount: 1))
    
    private func updateFrames() {
        playingCardsInUI = playingCardsInUI.filter({ (card) -> Bool in
            !card.isMemberOf(cardViewsInASet)
        })
        grid.frame = self.bounds
        if playingCardsInUI.count >= 27 {
            grid.cellCount = playingCardsInUI.count
            let aspectRatio = self.bounds.width/self.bounds.height > 0.7 ? 0.4 : self.bounds.width/self.bounds.height
            grid.layout = .aspectRatio(aspectRatio)
        } else {
            let columns = playingCardsInUI.count/3
            let rows = columns == 0 ? 0 : playingCardsInUI.count/columns
            grid.layout = .dimensions(rowCount: rows, columnCount: columns )
        }
    }
    
    func resetViews () {
        playingCardsInUI.removeAll()
        for aCard in self.subviews {
            aCard.removeFromSuperview()
        }
        grid = Grid(layout: Grid.Layout.dimensions(rowCount: 1, columnCount: 1))
        cardViewsInASet.removeAll()
    }

    
    
    func animate() {
        for card in playingCardsInUI  {
            if card.isMemberOf(cardViewsInASet) {
                card.updateView(isPartOfAset: true)
            }
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        updateFrames()
        
        for aPlayinCard in playingCardsInUI {
            guard let frame = grid[playingCardsInUI.index(of: aPlayinCard)!] else { return }
            if aPlayinCard.isFirstTimeInUI {
                    aPlayinCard.frame = self.superview!.viewWithTag(1)!.frame
                    aPlayinCard.isFaceDown = true
                    UIView.transition(with: aPlayinCard, duration: AnimationKeys.defaultDuration , options: [], animations: {
                        aPlayinCard.frame = frame
                        aPlayinCard.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                        aPlayinCard.transform = CGAffineTransform(rotationAngle: CGFloat(3.0))
                        self.addSubview(aPlayinCard)
                    }, completion: { final in
                        UIView.transition(with: aPlayinCard, duration: AnimationKeys.defaultDuration, options: [], animations: {
                            aPlayinCard.transform = CGAffineTransform.identity
                        }, completion: { _ in
                            UIView.transition(with: aPlayinCard, duration: 0.7, options: [.transitionFlipFromLeft], animations: {
                                aPlayinCard.isFaceDown = false
                                })
                            
                            })
                    })
            } else {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: AnimationKeys.defaultDuration, delay: 0.0, options: [.curveEaseInOut], animations: { aPlayinCard.frame = frame })
                }
            aPlayinCard.updateView(isPartOfAset: false)

            aPlayinCard.delegate = mainVC
            let tapRecognizer = UITapGestureRecognizer(target: aPlayinCard, action: #selector(aPlayinCard.selectOrdeselectCard(recognizer:)))
             aPlayinCard.addGestureRecognizer(tapRecognizer)
        }
        
        
        
    }
    

    var mainVC : MainViewController?{
        let tabVC = self.window?.rootViewController as? UITabBarController
        return tabVC?.viewControllers?.first as? MainViewController
    }
    
    
}



