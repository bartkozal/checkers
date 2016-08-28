//
//  GameScene.swift
//  Checkers
//
//  Created by bkzl on 26/08/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let tileSize: CGFloat = 36.0
    let boardSize = Settings.boardSize

    let gameLayer = SKNode()
    let boardLayer = SKNode()
    let piecesLayer = SKNode()

    var board: Board!
    var selectedPiece: Piece?

    override init(size: CGSize) {
        super.init(size: size)

        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let background = SKSpriteNode(color: Settings.backgroundColor, size: size)
        addChild(background)

        addChild(gameLayer)

        let layerPosition = CGPoint(x: -tileSize * CGFloat(boardSize) / 2,
                                    y: -tileSize * CGFloat(boardSize) / 2)

        boardLayer.position = layerPosition
        gameLayer.addChild(boardLayer)

        piecesLayer.position = layerPosition
        gameLayer.addChild(piecesLayer)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: piecesLayer)
        let (success, column, row) = convert(point: location)

        if success {
            if let piece = board.pieceAt(column: column, row: row) {
                selectedPiece = piece
                selectedPiece?.sprite?.zPosition = 1.0
                selectedPiece?.sprite?.size = CGSize(width: tileSize * 2, height: tileSize * 2)
                selectedPiece?.sprite?.position = location
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let piece = selectedPiece else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: piecesLayer)
        let (success, _, _) = convert(point: location)

        if success {
            piece.sprite?.position = location
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let piece = selectedPiece else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: piecesLayer)
        let (success, column, row) = convert(point: location)

        if success {
            tryMove(piece: piece, to: (column, row))
            tryCrown(piece: piece)
        } else {
            abandonMoveOf(piece: piece)
        }

        piece.sprite?.zPosition = 0.0
        piece.sprite?.size = CGSize(width: tileSize, height: tileSize)
        selectedPiece = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }

    private func tryMove(piece: Piece, to: (column: Int, row: Int)) {
        guard !board.isPieceAt(column: to.column, row: to.row) else {
            abandonMoveOf(piece: piece)
            return
        }

        guard piece.canMoveTo(column: to.column, row: to.row) else {
            abandonMoveOf(piece: piece)
            return
        }

        board.move(piece: piece, to: to)

        let movement = SKAction.move(to: pointFor(column: to.column, row: to.row), duration: 0.1)
        movement.timingMode = .linear
        piece.sprite?.run(movement)
    }

    private func abandonMoveOf(piece: Piece) {
        piece.sprite?.position = pointFor(column: piece.column, row: piece.row)
    }

    private func tryCrown(piece: Piece) {
        if piece.canCrownOn(row: piece.row) {
            switch piece.pieceType {
            case .white:
                piece.pieceType = .whiteKing
            case .red:
                piece.pieceType = .redKing
            default:
                return
            }
        }
    }

    func renderBoard() {
        boardLayer.removeAllChildren()
        piecesLayer.removeAllChildren()

        for row in 0..<boardSize {
            for column in 0..<boardSize {
                let size = CGSize(width: tileSize, height: tileSize)
                let color = tileColorFor(column: column, row: row)
                let position = pointFor(column: column, row: row)
                let tileNode = SKSpriteNode(color: color, size: size)
                tileNode.position = position
                boardLayer.addChild(tileNode)

                if let piece = board.pieceAt(column: column, row: row) {
                    let sprite = piece.sprite ?? SKSpriteNode(imageNamed: piece.pieceType.spriteName)
                    sprite.size = size
                    sprite.position = position
                    piecesLayer.addChild(sprite)
                    piece.sprite = sprite
                }
            }
        }
    }

    private func tileColorFor(column: Int, row: Int) -> UIColor {
        if row % 2 == 0 && column % 2 == 0 || row % 2 == 1 && column % 2 == 1 {
            return Settings.darkTilesColor
        } else {
            return Settings.lightTilesColor
        }
    }

    private func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(x: CGFloat(column) * tileSize + tileSize / 2,
                       y: CGFloat(row) * tileSize + tileSize / 2)
    }

    private func convert(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(boardSize) * tileSize &&
            point.y >= 0 && point.y < CGFloat(boardSize) * tileSize {
            return (true, Int(point.x / tileSize), Int(point.y / tileSize))
        } else {
            return (false, 0, 0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not used")
    }
}
