//
//  EmojiJarScene.swift
//  Challenge 3
//
//  Created by La Wun Eain  on 14/11/25.
//

import SpriteKit
import CoreGraphics

final class EmojiJarScene: SKScene {

    // ======= Jar sizing (tweak if you like) =======
    private let jarWidthRatio:  CGFloat = 0.78   // jar width vs screen width
    private let jarHeightRatio: CGFloat = 0.56   // jar height vs screen height
    private let jarBottomInset: CGFloat = 92     // lift jar off the bottom

    // Cute mason-jar proportions
    private let mouthWidthFactor: CGFloat = 0.90 // mouth ≈ 90% of body width (wide & cute)
    private let neckDrop: CGFloat       = 16     // short drop from mouth to shoulder
    private let shoulderDrop: CGFloat   = 28     // deeper = puffier shoulders
    private let shoulderCurveOut: CGFloat = 34   // horizontal “puff” of shoulders

    // Flat-bottom controls
    private let flatFraction: CGFloat = 0.60     // 0.50–0.70: fraction of body half that is flat half-width

    // Emoji (fixed size: change this one number)
    private let emojiRadius: CGFloat = 28
    private var  emojiFontSize: CGFloat { emojiRadius / 0.52 }

    // Ball physics (calm)
    private let ballRestitution: CGFloat = 0.08
    private let ballFriction: CGFloat    = 0.70
    private let ballLinDamp: CGFloat     = 0.20
    private let ballAngDamp: CGFloat     = 0.20

    // ======= Derived during layout =======
    private var baseY: CGFloat = 0
    private var topY: CGFloat = 0
    private var bodyHalf: CGFloat = 0
    private var mouthHalf: CGFloat = 0
    private var bodyTopY: CGFloat = 0
    private var shoulderY: CGFloat = 0

    // Nodes
    private var didSetup = false
    private var physicsNode: SKShapeNode?
    private var outlineNode: SKShapeNode?

    // MARK: - Lifecycle
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

        backgroundColor = .clear        // 👈 important: transparent scene
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)

        // keep everything on screen
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.friction = 0.2

        rebuildJar()
    }

    // MARK: - Build cute wide-mouth mason jar with flat bottom
    private func rebuildJar() {
        outlineNode?.removeFromParent()
        physicsNode?.removeFromParent()

        let W = size.width  * jarWidthRatio
        let H = size.height * jarHeightRatio
        let cx = size.width / 2

        baseY = jarBottomInset
        topY  = baseY + H

        // Inner widths
        bodyHalf  = W * 0.40
        mouthHalf = bodyHalf * mouthWidthFactor

        // Shoulder positions
        shoulderY = topY - neckDrop
        bodyTopY  = shoulderY - shoulderDrop

        // ------- Flat bottom geometry -------
        let flatHalf = max(2, bodyHalf * flatFraction)
        let cornerR  = max(2, bodyHalf - flatHalf)
        let leftBodyX  = cx - bodyHalf
        let rightBodyX = cx + bodyHalf

        // ------- Physics contour (open at top) -------
        let phys = CGMutablePath()

        // Left mouth -> left shoulder
        phys.move(to: CGPoint(x: cx - mouthHalf, y: topY))
        phys.addQuadCurve(
            to: CGPoint(x: leftBodyX, y: bodyTopY),
            control: CGPoint(x: cx - mouthHalf - shoulderCurveOut, y: shoulderY + 14)
        )

        // Left wall
        phys.addLine(to: CGPoint(x: leftBodyX, y: baseY + cornerR))

        // Left bottom corner
        phys.addArc(center: CGPoint(x: cx - flatHalf, y: baseY + cornerR),
                    radius: cornerR,
                    startAngle: .pi, endAngle: 3 * .pi / 2,
                    clockwise: false)

        // Flat bottom
        phys.addLine(to: CGPoint(x: cx + flatHalf, y: baseY))

        // Right bottom corner
        phys.addArc(center: CGPoint(x: cx + flatHalf, y: baseY + cornerR),
                    radius: cornerR,
                    startAngle: 3 * .pi / 2, endAngle: 0,
                    clockwise: false)

        // Right wall
        phys.addLine(to: CGPoint(x: rightBodyX, y: bodyTopY))

        // Right shoulder -> mouth
        phys.addQuadCurve(
            to: CGPoint(x: cx + mouthHalf, y: topY),
            control: CGPoint(x: cx + mouthHalf + shoulderCurveOut, y: shoulderY + 14)
        )

        // Physics body
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

        // Visible outline
        let outline = SKShapeNode(path: phys)
        outline.strokeColor = .black
        outline.lineWidth  = 10
        outline.lineJoin   = .round
        outline.lineCap    = .round
        outline.fillColor  = .clear
        outline.zPosition  = 5
        addChild(outline)
        outlineNode = outline

        // Rim guides
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

    // MARK: - Actions
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
