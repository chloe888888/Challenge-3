//
//  EmojiJarScene.swift
//  Challenge 3
//
//  Created by La Wun Eain on 14/11/25.
//

import SpriteKit
import CoreGraphics
import SwiftUICore

final class EmojiJarScene: SKScene {


    private let jarWidthRatio: CGFloat = 0.70
    private let jarHeightRatio: CGFloat = 0.60
    private let jarBottomInset: CGFloat = 92
    private let mouthWidthFactor: CGFloat = 0.90
    private let neckDrop: CGFloat = 16
    private let shoulderDrop: CGFloat = 28
    private let shoulderCurveOut: CGFloat = 52
    private let flatFraction: CGFloat = 0.60


    private let emojiRadius: CGFloat = 20
    private var emojiFontSize: CGFloat { emojiRadius / 0.52 }

    private let ballRestitution: CGFloat = 0.05
    private let ballFriction: CGFloat = 0.80
    private let ballLinDamp: CGFloat = 0.35
    private let ballAngDamp: CGFloat = 0.30


    private var baseY: CGFloat = 0
    private var topY: CGFloat = 0
    private var bodyHalf: CGFloat = 0
    private var mouthHalf: CGFloat = 0
    private var shoulderY: CGFloat = 0
    private var bodyTopY: CGFloat = 0

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
        physicsBody?.friction = 0.3

        rebuildJar()
    }

 
    private func rebuildJar() {

        outlineNode?.removeFromParent()
        physicsNode?.removeFromParent()

        let W = size.width * jarWidthRatio
        let H = size.height * jarHeightRatio
        let cx = size.width / 2

        baseY = jarBottomInset
        topY = baseY + H

        bodyHalf = W * 0.40
        mouthHalf = bodyHalf * mouthWidthFactor

        shoulderY = topY - neckDrop
        bodyTopY = shoulderY - shoulderDrop

        let flatHalf = max(2, bodyHalf * flatFraction)
        let cornerR = max(2, bodyHalf - flatHalf)
        let leftBodyX = cx - bodyHalf
        let rightBodyX = cx + bodyHalf

        let path = CGMutablePath()

        // Mouth
        path.move(to: CGPoint(x: cx - mouthHalf, y: topY))

        // Left curve
        path.addQuadCurve(
            to: CGPoint(x: leftBodyX, y: bodyTopY),
            control: CGPoint(
                x: cx - mouthHalf - shoulderCurveOut,
                y: shoulderY + 14
            )
        )

        // Left wall
        path.addLine(to: CGPoint(x: leftBodyX, y: baseY + cornerR))

        // Bottom left corner
        path.addArc(center: CGPoint(x: cx - flatHalf, y: baseY + cornerR),
                    radius: cornerR,
                    startAngle: .pi,
                    endAngle: 3 * .pi / 2,
                    clockwise: false)

        // Bottom flat
        path.addLine(to: CGPoint(x: cx + flatHalf, y: baseY))

        // Bottom right corner
        path.addArc(center: CGPoint(x: cx + flatHalf, y: baseY + cornerR),
                    radius: cornerR,
                    startAngle: 3 * .pi / 2,
                    endAngle: 0,
                    clockwise: false)

        // Right wall
        path.addLine(to: CGPoint(x: rightBodyX, y: bodyTopY))

        // Right curve
        path.addQuadCurve(
            to: CGPoint(x: cx + mouthHalf, y: topY),
            control: CGPoint(
                x: cx + mouthHalf + shoulderCurveOut,
                y: shoulderY + 14
            )
        )

        // Physics jar
        let physNode = SKShapeNode(path: path)
        physNode.strokeColor = .clear
        physNode.zPosition = 1
        physNode.physicsBody = SKPhysicsBody(edgeChainFrom: path)
        physNode.physicsBody?.isDynamic = false
        physNode.physicsBody?.restitution = 0.05
        physNode.physicsBody?.friction = 0.6
        addChild(physNode)
        physicsNode = physNode

        // Visual outline
        let outline = SKShapeNode(path: path)
        outline.strokeColor = .black
        outline.lineWidth = 8
        outline.lineJoin = .round
        outline.zPosition = 4
        addChild(outline)
        outlineNode = outline

        // Rim supports
        addInvisibleSupport(from: CGPoint(x: cx - mouthHalf, y: topY),
                            to: CGPoint(x: cx - mouthHalf - 20, y: topY + 20))

        addInvisibleSupport(from: CGPoint(x: cx + mouthHalf, y: topY),
                            to: CGPoint(x: cx + mouthHalf + 20, y: topY + 20))
    }

    private func addInvisibleSupport(from a: CGPoint, to b: CGPoint) {
        let p = CGMutablePath()
        p.move(to: a)
        p.addLine(to: b)
        let node = SKShapeNode(path: p)
        node.strokeColor = .clear
        node.physicsBody = SKPhysicsBody(edgeChainFrom: p)
        node.physicsBody?.isDynamic = false
        addChild(node)
    }


    func clearAll() {
        for node in children where node is SKLabelNode {
            node.removeFromParent()
        }
    }

    func removeEmoji(_ emoji: String) {
        if let label = children
            .compactMap({ $0 as? SKLabelNode })
            .first(where: {$0.text == emoji }) {
            label.removeFromParent()
        }
    }

    func updateEmoji(from old: String, to new: String) {
        if let label = children
            .compactMap({ $0 as? SKLabelNode })
            .first(where: { $0.text == old }) {

            label.text = new
            return
        }


        dropEmoji(new)
    }


    func dropEmoji(_ emoji: String) {

        let label = SKLabelNode(text: emoji)
        label.fontName = "AppleColorEmoji"
        label.fontSize = emojiFontSize
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.zPosition = 10

  
        let cx = size.width / 2
        let band = max(8, (mouthHalf - emojiRadius) * 0.12)

        let spawnX = cx + CGFloat.random(in: -band...band)
        let spawnY = topY - emojiRadius - 6

        label.position = CGPoint(x: spawnX, y: spawnY)
        addChild(label)

        label.physicsBody = SKPhysicsBody(circleOfRadius: emojiRadius)
        label.physicsBody?.allowsRotation = true
        label.physicsBody?.restitution = ballRestitution
        label.physicsBody?.friction = ballFriction
        label.physicsBody?.linearDamping = ballLinDamp
        label.physicsBody?.angularDamping = ballAngDamp


        let dx = CGFloat.random(in: -0.2...0.2)
        let dy = CGFloat.random(in: -0.4...0.1)
        label.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
    }
}
