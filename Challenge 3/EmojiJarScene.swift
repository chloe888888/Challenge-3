//
//  EmojiJarScene.swift
//  Challenge 3
//
//  Created by La Wun Eain  on 14/11/25.
//

import SpriteKit
import CoreGraphics
import SwiftUICore

final class EmojiJarScene: SKScene {

    var decorShop = Decor()
 
    private let jarWidthRatio:  CGFloat = 0.78
    private let jarHeightRatio: CGFloat = 0.56
    private let jarBottomInset: CGFloat = 92

    private let mouthWidthFactor: CGFloat = 0.90
    private let neckDrop: CGFloat       = 16
    private let shoulderDrop: CGFloat   = 28
    private let shoulderCurveOut: CGFloat = 34

    
    private let flatFraction: CGFloat = 0.60

    
    private let emojiRadius: CGFloat = 28
    private var  emojiFontSize: CGFloat { emojiRadius / 0.52 }

    
    private let ballRestitution: CGFloat = 0.08
    private let ballFriction: CGFloat    = 0.70
    private let ballLinDamp: CGFloat     = 0.20
    private let ballAngDamp: CGFloat     = 0.20

    
    private var baseY: CGFloat = 0
    private var topY: CGFloat = 0
    private var bodyHalf: CGFloat = 0
    private var mouthHalf: CGFloat = 0
    private var bodyTopY: CGFloat = 0
    private var shoulderY: CGFloat = 0

   
    private var didSetup = false
    private var physicsNode: SKShapeNode?
    private var outlineNode: SKShapeNode?


    override func didMove(to view: SKView) {
        super.didMove(to: view)
        configureIfNeeded()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        rebuildJar()
    }

    private func configureIfNeeded() {
        guard !didSetup else { return }
        didSetup = true

        backgroundColor = .clear
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)

        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.friction = 0.2

        rebuildJar()
    }

    
    private func rebuildJar() {
        outlineNode?.removeFromParent()
        physicsNode?.removeFromParent()

        let W = size.width  * jarWidthRatio
        let H = size.height * jarHeightRatio
        let cx = size.width / 2

        baseY = jarBottomInset
        topY  = baseY + H

        
        bodyHalf  = W * 0.40
        mouthHalf = bodyHalf * mouthWidthFactor

        
        shoulderY = topY - neckDrop
        bodyTopY  = shoulderY - shoulderDrop

        
        let flatHalf = max(2, bodyHalf * flatFraction)
        let cornerR  = max(2, bodyHalf - flatHalf)
        let leftBodyX  = cx - bodyHalf
        let rightBodyX = cx + bodyHalf

        
        let phys = CGMutablePath()

        
        phys.move(to: CGPoint(x: cx - mouthHalf, y: topY))
        phys.addQuadCurve(
            to: CGPoint(x: leftBodyX, y: bodyTopY),
            control: CGPoint(x: cx - mouthHalf - shoulderCurveOut, y: shoulderY + 14)
        )

        
        phys.addLine(to: CGPoint(x: leftBodyX, y: baseY + cornerR))

        
        phys.addArc(center: CGPoint(x: cx - flatHalf, y: baseY + cornerR),
                    radius: cornerR,
                    startAngle: .pi, endAngle: 3 * .pi / 2,
                    clockwise: false)

        
        phys.addLine(to: CGPoint(x: cx + flatHalf, y: baseY))

        
        phys.addArc(center: CGPoint(x: cx + flatHalf, y: baseY + cornerR),
                    radius: cornerR,
                    startAngle: 3 * .pi / 2, endAngle: 0,
                    clockwise: false)

        
        phys.addLine(to: CGPoint(x: rightBodyX, y: bodyTopY))

        
        phys.addQuadCurve(
            to: CGPoint(x: cx + mouthHalf, y: topY),
            control: CGPoint(x: cx + mouthHalf + shoulderCurveOut, y: shoulderY + 14)
        )

        
        let physNode = SKShapeNode(path: phys)
        physNode.strokeColor = .clear
        physNode.lineWidth = 1
        physNode.zPosition = 1
        physNode.physicsBody = SKPhysicsBody(edgeChainFrom: phys)
        physNode.physicsBody?.isDynamic = false
        physNode.physicsBody?.friction = 0.6
        physNode.physicsBody?.restitution = 0.04
        addChild(physNode)
        physicsNode = physNode

        
        let outline = SKShapeNode(path: phys)
        outline.strokeColor = .black
        outline.lineWidth  = 10
        outline.lineJoin   = .round
        outline.lineCap    = .round
        outline.fillColor  = .clear
        outline.zPosition  = 5
        addChild(outline)
        outlineNode = outline

        
        addRimGuide(from: CGPoint(x: cx - mouthHalf, y: topY),
                    to:   CGPoint(x: cx - mouthHalf + 10, y: topY - 10))
        addRimGuide(from: CGPoint(x: cx + mouthHalf, y: topY),
                    to:   CGPoint(x: cx + mouthHalf - 10, y: topY - 10))
    }

    private func addRimGuide(from a: CGPoint, to b: CGPoint) {
        let p = CGMutablePath()
        p.move(to: a)
        p.addLine(to: b)
        let g = SKShapeNode(path: p)
        g.strokeColor = .clear
        g.lineWidth = 1
        g.zPosition = 2
        g.physicsBody = SKPhysicsBody(edgeChainFrom: p)
        g.physicsBody?.isDynamic = false
        addChild(g)
    }


    func dropEmoji(_ emoji: String) {
        let label = SKLabelNode(text: emoji)
        label.fontName = "AppleColorEmoji"
        label.fontSize = emojiFontSize
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.zPosition = 10

        let cx = size.width / 2
        let band = max(4, mouthHalf - emojiRadius + 12)
        let spawnX = cx + CGFloat.random(in: -band...band)
        let spawnY = topY + emojiRadius + 6
        label.position = CGPoint(x: spawnX, y: spawnY)
        addChild(label)

        label.physicsBody = SKPhysicsBody(circleOfRadius: emojiRadius)
        label.physicsBody?.allowsRotation = true
        label.physicsBody?.restitution = ballRestitution
        label.physicsBody?.friction = ballFriction
        label.physicsBody?.linearDamping = ballLinDamp
        label.physicsBody?.angularDamping = ballAngDamp

        label.physicsBody?.applyImpulse(CGVector(dx: CGFloat.random(in: -2...2), dy: -1))
    }

    func clearAll() {
        for node in children where node is SKLabelNode { node.removeFromParent() }
    }
    
}
