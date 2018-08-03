//
//  MyAnimation.swift
//  SetGame
//
//  Created by Felipe Montoya on 2/28/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class FlyAwayAnimation: UIDynamicBehavior {
    
  private  lazy var collission: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        behavior.collisionMode = UICollisionBehaviorMode.boundaries
        return behavior
    } ()
    
 
    
  private  lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.elasticity = 0.95
        behavior.resistance = 0.13
        behavior.friction = 0.23
        return behavior
    }()
    
    
  private  func pushBehavior(_ item: UIDynamicItem) {
        let pushBehavior = UIPushBehavior(items: [item], mode: .instantaneous)
        var random: Double
        repeat {
            random = Double(arc4random_uniform(4))
        } while (random == 0.0)
        let radians = toCenter(item)
        pushBehavior.angle = CGFloat(radians)
        pushBehavior.magnitude = 15.0
        pushBehavior.action = { [unowned pushBehavior, weak self] in
            self?.removeChildBehavior(pushBehavior)
        }
        self.addChildBehavior(pushBehavior)
        
    }
    
    
    
   private func  snapBehavior(_ item: UIDynamicItem, point: CGPoint){
        let snapBehavior = UISnapBehavior(item: item, snapTo: point)
        snapBehavior.damping = 0.2
        self.addChildBehavior(snapBehavior)

    }
    
    
    func snapItem(_ item: UIDynamicItem,to trash: CGPoint) {
        snapBehavior(item, point: trash)
    }
    
    func addItem(_ item: UIDynamicItem){
        collission.addItem(item)
        itemBehavior.addItem(item)
        pushBehavior(item)
    }
    
    
    func removeItem(_ item: UIDynamicItem){
        collission.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    
    override init() {
        super.init()
        addChildBehavior(collission)
        addChildBehavior(itemBehavior)
    }
    
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
}


extension FlyAwayAnimation {
    
    func toCenter(_ item:UIDynamicItem) -> Double {
        guard let view = item as? UIView  else { print("CouldtCast Item as View"); return Double.pi}
            guard let superView = view.superview else { print("CouldGet SuperView"); return Double.pi }
                let center = CGPoint.init(x: superView.bounds.midX, y: superView.bounds.midY)
                let viewPosition: CGPoint = CGPoint.init(x: view.frame.midX, y: view.frame.midY)
                let deltaX = Double(center.x - viewPosition.x)
                let deltaY = Double(center.y - viewPosition.y)
                var radians: Double = 0
                if deltaX > 0 {
                    switch deltaY {
                        case  0.01... : radians =  deltaY.magnitude/deltaX.magnitude
                        case ..<0:  radians = (Double.pi) * 2 - deltaY.magnitude/deltaX.magnitude
                        case 0: fallthrough
                        default: radians = 0
                    }
                } else if deltaX < 0 {
                    switch deltaY {
                        case  0.01... : radians = (Double.pi) - deltaY.magnitude/deltaX.magnitude
                        case ..<0:  radians = (Double.pi) + deltaY.magnitude/deltaX.magnitude
                        case 0: fallthrough
                        default: radians = (Double.pi)
                    }
                }else if deltaX == 0 {
                    switch deltaY {
                        case  0.01... : radians = (Double.pi)/2
                        case ..<0:  radians =  ((Double.pi) * 3)/4
                        case 0: fallthrough
                        default: radians = (Double.pi)/2
                    }
                }
        
            return radians
    }
    
    
}
