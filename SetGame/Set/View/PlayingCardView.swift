//
//  PlayingCardView.swift
//  SetGame
//
//  Created by Felipe Montoya on 2/20/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit




protocol PlayingCardViewDelegate {
    func didSelectedACard(_ cardView: PlayingCardView)
    func didDeselectedACard(_ cardView: PlayingCardView)
}

extension PlayingCardView {
    
    struct PropertyKeys {
        static var width: CGFloat = 1.0
        static var height: CGFloat = 1.0
        static var ovalHeight: CGFloat {
           return height * 0.4
        }
    }

}

@IBDesignable
class PlayingCardView: UIView {

    var isFaceDown = true {
        didSet {
            self.backgroundColor = isFaceDown ? #colorLiteral(red: 0.8156862745, green: 0.9098039216, blue: 0.2470588235, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0); setNeedsDisplay()
        }
    }
    var isASelectedCard = false
    var isFirstTimeInUI = true
    var isTapEnable = true  {
        didSet {
            if isTapEnable == false {
                isASelectedCard = false
            }
        }
    }
    var delegate: PlayingCardViewDelegate?
    
    
    @IBInspectable  var color: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
@IBInspectable  var number: Int =  0 {
    didSet {
        setNeedsDisplay()
    }
}
    @IBInspectable var shading: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var symbol: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
 

    @objc func selectOrdeselectCard (recognizer: UITapGestureRecognizer? = nil) {
        
        if let state = recognizer?.state {
            switch state {
            case .ended :
                guard isTapEnable else { return }
                isASelectedCard = !isASelectedCard
                if isASelectedCard {
                    self.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                    self.layer.borderWidth = 4.0
                    delegate?.didSelectedACard(self)
                } else {
                    self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.layer.borderWidth = 1.0
                    delegate?.didDeselectedACard(self)
                }
            default: break
            }
        } else {
            guard isTapEnable else { return }
            isASelectedCard = !isASelectedCard
            if isASelectedCard {
                self.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                self.layer.borderWidth = 4.0
                delegate?.didSelectedACard(self)
            } else {
                self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.layer.borderWidth = 1.0
                delegate?.didDeselectedACard(self)
            }
            
        }
        
        
            
    }
    
    
    
    private func setColor() {
        switch color {
            case "red": UIColor.red.setFill()
            UIColor.red.setStroke()
        case "green": UIColor.green.setFill()
        UIColor.green.setStroke()
        case "purple": UIColor.purple.setFill()
        UIColor.purple.setStroke()
        default: return
        }
        
        
        
    }
    
    
    
    private func drawCard() {
        
        
        
         var path: UIBezierPath!
        
        
        
        func fillSymbol() {
            setColor()
            switch shading {
                case "solid": path.fill()
                case "stripped":
                    path.lineWidth = 0.4
                    path.stroke()
                    let context = UIGraphicsGetCurrentContext()
                    context?.saveGState()
                for increment in 1...25 {
                    path.move(to: CGPoint(x: self.bounds.maxX * 0.04 * CGFloat(increment), y: 0))
                    path.addLine(to: CGPoint(x: self.bounds.maxX * 0.04 * CGFloat(increment), y: self.bounds.maxY))
                    path.lineWidth = 1.0
                }
                    
                   path.addClip()
                    path.stroke()
                    context?.restoreGState()
             
                
                
                
                case "open": path.stroke()
                default : return
            }
        }
        
        
        
        func drawSymbol (at startPoint: CGPoint) {
           
            if symbol != "oval" {
                path = UIBezierPath()
            } else {
                path = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: startPoint.x - PropertyKeys.width/2, y: startPoint.y - PropertyKeys.ovalHeight/2), size: CGSize(width: PropertyKeys.width, height: PropertyKeys.ovalHeight)))
            }
            
            switch symbol{
                
            case "diamond":
                path.move(to: CGPoint(x:startPoint.x,y: startPoint.y - PropertyKeys.height/2) )
                path.addLine(to: CGPoint(x:startPoint.x - PropertyKeys.width/4,y: startPoint.y) )
                path.addLine(to: CGPoint(x:startPoint.x,y: startPoint.y + PropertyKeys.height/2) )
                path.addLine(to: CGPoint(x:startPoint.x + PropertyKeys.width/4,y: startPoint.y) )
                path.close()
                path.lineWidth = 2.0
                fillSymbol()
            case "squiggle":
                path.addArc(withCenter: CGPoint(x:startPoint.x - PropertyKeys.width/2 * 0.8,y: startPoint.y - PropertyKeys.height/2 + PropertyKeys.width * 0.2), radius: PropertyKeys.width * 0.2, startAngle: CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true)
                path.move(to: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y + PropertyKeys.width * 0.4) )
                path.addCurve(to: CGPoint(x:startPoint.x + PropertyKeys.width/2 * 0.8,y: startPoint.y + PropertyKeys.height/2), controlPoint1: CGPoint(x:startPoint.x - PropertyKeys.width/2 * 0.05,y: startPoint.y - PropertyKeys.height/2 * 0.5), controlPoint2: CGPoint(x:startPoint.x - PropertyKeys.width/2 ,y: startPoint.y + PropertyKeys.height/2 * 0.8))
                path.move(to: CGPoint(x:startPoint.x + PropertyKeys.width/2 * 0.8,y: startPoint.y + PropertyKeys.height/2))
                path.addArc(withCenter: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y - PropertyKeys.width * 0.2), radius: PropertyKeys.width * 0.2, startAngle: CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: false)
                path.move(to: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y) )
                path.addCurve(to: CGPoint(x:startPoint.x - PropertyKeys.width/2 * 0.8,y: startPoint.y - PropertyKeys.height/2), controlPoint1: CGPoint(x:path.currentPoint.x - PropertyKeys.width/2 * 0.1,y: path.currentPoint.y - PropertyKeys.height/2 * 0.05), controlPoint2: CGPoint(x:startPoint.x + PropertyKeys.width/2 ,y: startPoint.y - PropertyKeys.height/2 * 0.8))
                path.lineWidth = 2.0
                fillSymbol()
            case "oval":
                path.lineWidth = 2.0
                fillSymbol()
            default:
                return
            }
        }
        
        
        
 
        
        switch number {
        case 1:
            PropertyKeys.width = (self.bounds.size.width * 0.85)
            PropertyKeys.height = (self.bounds.size.height * 0.85)
            let center = CGPoint(x:self.bounds.midX , y: self.bounds.midY)
            drawSymbol(at: center)
        case 2:
            PropertyKeys.width = (self.bounds.size.width * 0.50)
            PropertyKeys.height = (self.bounds.size.height * 0.50)
            var center = CGPoint(x:self.bounds.midX - PropertyKeys.width/2 , y: self.bounds.midY )
            drawSymbol(at: center)
            center = CGPoint(x:self.bounds.midX + PropertyKeys.width/2 , y: self.bounds.midY )
            drawSymbol(at: center)
        case 3:
            PropertyKeys.width = (self.bounds.size.width * 0.30)
            PropertyKeys.height = (self.bounds.size.height * 0.30)
            
            var center = CGPoint(x:self.bounds.midX, y: self.bounds.midY - PropertyKeys.height)
            drawSymbol(at: center)
            
            center = CGPoint(x:self.bounds.midX, y: self.bounds.midY )
            drawSymbol(at: center)
            
            center = CGPoint(x:self.bounds.midX, y: self.bounds.midY + PropertyKeys.height)
            drawSymbol(at: center)
        default:
            return
        }
        
    }
    
    
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 16.0
        if !isFaceDown {
            drawCard()
        } 
    }
    
    
    
    
    func isMemberOf (_ set: Set<PlayingCardView> ) -> Bool {
        for cardView in set {
            if cardView.color == self.color &&
            cardView.symbol == self.symbol &&
            cardView.shading == self.shading &&
                cardView.number == self.number {
                return true
            }
        }
        return false
    }
    
    static var cardInSetCounter = 0
    func updateView(isPartOfAset: Bool){
        self.isFirstTimeInUI = false
        self.layer.cornerRadius = 8.0
        if isPartOfAset {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: 0.2, options: [],
                                                           animations: {
                                                            self.backgroundColor =  #colorLiteral(red: 1, green: 0.9617139697, blue: 0.8048382401, alpha: 1)
                                                            self.layer.borderWidth = 1.0
                                                            self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                                                           
                                            
            })
            self.superview?.superview!.addSubview(self)
            self.flyAnimation()
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (timer) in
                                                self.animator.removeAllBehaviors()
                                                           self.snapAnimation() })

            self.isTapEnable = false
            PlayingCardView.cardInSetCounter += 1
        } else {
            self.layer.borderWidth = 0.5
            self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.isTapEnable = true
        }
        
    }
    
    
    var animator: UIDynamicAnimator! {
        didSet {
            animator.delegate = self
        }
    }
    var flyAwayAnimation: FlyAwayAnimation!

}

extension PlayingCardView: UIDynamicAnimatorDelegate {
    

    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0.0, options: [], animations: {
             self.bounds = self.superview?.superview?.viewWithTag(2)?.bounds ?? CGRect.zero
        }) { (_) in
            UIView.transition(with: self, duration: 0.7, options: [.curveEaseOut,.transitionFlipFromLeft], animations: {
                self.isFaceDown = true
                self.layer.borderWidth = 0.1
                self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                
            }, completion: { _ in
                self.isHidden = true
                self.superview?.superview?.viewWithTag(2)?.isHidden = false
                
                self.removeFromSuperview()
                
            }
            )
        }
        
    }
    
    func flyAnimation() {
       
        animator = UIDynamicAnimator (referenceView: self.superview!)
        flyAwayAnimation = FlyAwayAnimation(in: animator)
        flyAwayAnimation.addItem(self)
    }
    
    func snapAnimation () {
        animator = UIDynamicAnimator (referenceView: self.superview!)
        flyAwayAnimation = FlyAwayAnimation(in: animator)
        var trashPoint = CGPoint(x: 0, y: 0)
        if let possibleSubView = self.superview!.superview!.viewWithTag(2){
            trashPoint = CGPoint(x: possibleSubView.frame.midX, y: possibleSubView.frame.midY)
        }else {
            print("No subviews")
        }
        flyAwayAnimation.snapItem(self, to: trashPoint)
    }
    
    
}






