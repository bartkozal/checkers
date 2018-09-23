import SpriteKit

protocol GameSceneDelegate: class {
    func didFinishMove()
}

// FIXME Piece should have access to the board, then move most of the logic from scene to pieces
class GameScene: SKScene {
    var tileSize: CGFloat!
    var pieceSize: CGFloat!

    let dimension = Settings.boardSize.dimension

    let gameLayer = SKNode()
    let boardLayer = SKNode()
    let piecesLayer = SKNode()

    var board: Board!
    var draggedPiece: Piece?
    var captures = [Piece]()
    var capturing = false
    var capturingInSequence = false
    var capturingPiece: Piece?
    var capturingPieces = [Piece]()
    var capturingTiles = [SKSpriteNode]()

    var mandatoryCaptureLabel: UILabel!
    var haveMandatoryCaptures: Bool {
        return !capturingPieces.isEmpty
    }

    weak var gameSceneDelegate: GameSceneDelegate?

    override init(size: CGSize) {
        super.init(size: size)

        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        tileSize = size.width / CGFloat(dimension)
        pieceSize = tileSize * 0.9

        addChild(gameLayer)

        let layerPosition = CGPoint(x: -tileSize * CGFloat(dimension) / 2,
                                    y: -tileSize * CGFloat(dimension) / 2)

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
            if let piece = board.pieceAt(column: column, row: row), piece.pieceSet == board.activePieceSet {
                if board.mandatoryCapturing && haveMandatoryCaptures {
                    guard capturingPieces.contains(piece) else { return }
                }

                if capturingPiece != nil {
                    guard piece == capturingPiece! else { return }
                }

                draggedPiece = piece

                capturing = capturesFor(piece: piece)

                piece.sprite?.zPosition = 1.0
                piece.sprite?.size = CGSize(width: tileSize * 2, height: tileSize * 2)
                piece.sprite?.position = location
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let piece = draggedPiece else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: piecesLayer)
        let (success, _, _) = convert(point: location)

        if success {
            piece.sprite?.position = location
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let piece = draggedPiece else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: piecesLayer)
        let (success, column, row) = convert(point: location)

        if success {
            if capturing {
                tryCapture(piece: piece, to: (column, row))
            } else {
                tryMove(piece: piece, to: (column, row))
            }
        } else {
            abandonMoveOf(piece: piece)
        }

        piece.sprite?.zPosition = 0.0
        piece.sprite?.size = CGSize(width: pieceSize, height: pieceSize)
        draggedPiece = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }

    private func capturesFor(piece: Piece) -> Bool {
        captures.removeAll()

        for row in -piece.captureRange...piece.captureRange {
            for column in -piece.captureRange...piece.captureRange {
                guard row != 0 else { continue }
                guard column != 0 else { continue }
                guard abs(row) == abs(column) else { continue }

                if !board.backwardJumps && !capturingInSequence && piece.pieceType == .pawn {
                    if piece.pieceSet == .white {
                        guard row != -1 else { continue }
                    } else {
                        guard row != 1 else { continue }
                    }
                }

                let rowToFinishMove = piece.row + row + 1 * (row / abs(row))
                let columnToFinishMove = piece.column + column + 1 * (column / abs(column))

                guard 0..<dimension ~= rowToFinishMove else { continue }
                guard 0..<dimension ~= columnToFinishMove else { continue }

                guard !board.isPieceAt(column: columnToFinishMove, row: rowToFinishMove) else { continue }

                let rowToCaputre = piece.row + row
                let columnToCapture = piece.column + column

                guard let pieceToCapture = board.pieceAt(column: columnToCapture, row: rowToCaputre) else { continue }
                guard piece.canCapturePieceOf(set: pieceToCapture.pieceSet) else { continue }

                var ownPieces = 0
                var opponentPieces = 0
                let distance = abs(columnToFinishMove - piece.column)

                for n in 1..<distance {
                    if let pieceToCheck = board.pieceAt(column: piece.column + n * ((columnToFinishMove - piece.column) / distance), row: piece.row + n * ((rowToFinishMove - piece.row) / distance)) {
                        if piece.canCapturePieceOf(set: pieceToCheck.pieceSet) {
                            opponentPieces += 1
                        } else {
                            ownPieces += 1
                        }
                    }
                }
                guard ownPieces == 0 && opponentPieces == 1 else { continue }

                captures.append(pieceToCapture)
            }
        }

        return !captures.isEmpty
    }

    private func tryCapture(piece: Piece, to: (column: Int, row: Int)) {
        guard !captures.isEmpty else {
            abandonMoveOf(piece: piece)
            return
        }

        guard !board.isPieceAt(column: to.column, row: to.row) else {
            abandonMoveOf(piece: piece)
            return
        }

        guard piece.canMoveOnCaptureTo(column: to.column, row: to.row) else {
            abandonMoveOf(piece: piece)
            return
        }

        let distance = abs(to.column - piece.column)

        var pieceToCapture: Piece?
        var ownPieces = 0
        var opponentPieces = 0

        for n in 1..<distance {
            if let pieceToCheck = board.pieceAt(column: piece.column + n * ((to.column - piece.column) / distance), row: piece.row + n * ((to.row - piece.row) / distance)) {
                if piece.canCapturePieceOf(set: pieceToCheck.pieceSet) {
                    opponentPieces += 1
                } else {
                    ownPieces += 1
                }

                for capture in captures where capture.column == pieceToCheck.column && capture.row == pieceToCheck.row {
                    pieceToCapture = capture
                }
            }
        }

        guard ownPieces == 0 && opponentPieces == 1 else {
            abandonMoveOf(piece: piece)
            return
        }

        if let capturedPiece = pieceToCapture {
            guard piece.canCapturePieceOf(set: capturedPiece.pieceSet) else {
                abandonMoveOf(piece: piece)
                return
            }

            board.capture(piece: capturedPiece)
            board.move(piece: piece, to: to)
            capturingPiece = piece


            let movement = SKAction.move(to: pointFor(column: to.column, row: to.row), duration: 0.1)
            movement.timingMode = .linear
            capturedPiece.sprite?.removeFromParent()

            for tile in capturingTiles {
                tile.color = Settings.darkTilesColor
            }

            if board.backwardJumpsInSequences {
                capturingInSequence = true
            }

            if capturesFor(piece: piece) {
                piece.sprite?.run(movement)
            } else {
                capturing = false
                capturingPiece = nil
                piece.sprite?.run(movement) { [unowned self] in
                    self.tryCrown(piece: piece)
                    self.finishMove(at: self.pointFor(column: to.column, row: to.row))
                }
            }
        }
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

        if piece.pieceType == .king {
            let distance = abs(to.column - piece.column)
            for n in 1..<distance {
                if board.isPieceAt(column: piece.column + n * ((to.column - piece.column) / distance), row: piece.row + n * ((to.row - piece.row) / distance)) {
                    abandonMoveOf(piece: piece)
                    return
                }
            }
        }

        board.move(piece: piece, to: to)

        let movement = SKAction.move(to: pointFor(column: to.column, row: to.row), duration: 0.1)
        movement.timingMode = .linear
        piece.sprite?.run(movement) { [unowned self] in
            self.tryCrown(piece: piece)
            self.finishMove(at: self.pointFor(column: to.column, row: to.row))
        }
    }

    private func abandonMoveOf(piece: Piece) {
        piece.sprite?.position = pointFor(column: piece.column, row: piece.row)
    }

    private func finishMove(at location: CGPoint) {
        let tile = boardLayer.atPoint(location) as! SKSpriteNode
        tile.color = Settings.lastMoveTileColor
        self.gameSceneDelegate?.didFinishMove()
    }

    private func tryCrown(piece: Piece) {
        if piece.canCrownOn(row: piece.row) {
            piece.crown()
        }
    }

    func renderBoard() {
        boardLayer.removeAllChildren()
        piecesLayer.removeAllChildren()

        for row in 0..<dimension {
            for column in 0..<dimension {
                let size = CGSize(width: tileSize, height: tileSize)
                let color = tileColorFor(column: column, row: row)
                let position = pointFor(column: column, row: row)
                let tileNode = SKSpriteNode(color: color, size: size)
                tileNode.position = position
                boardLayer.addChild(tileNode)

                if let piece = board.pieceAt(column: column, row: row) {
                    let sprite = piece.sprite ?? SKSpriteNode(imageNamed: piece.spriteName)
                    sprite.size = CGSize(width: pieceSize, height: pieceSize)
                    sprite.position = position

                    piecesLayer.addChild(sprite)

                    piece.sprite = sprite

                    if board.mandatoryCapturing {
                        if piece.pieceSet == board.activePieceSet && capturesFor(piece: piece) {
                            let location = pointFor(column: piece.column, row: piece.row)
                            let tile = boardLayer.atPoint(location) as! SKSpriteNode
                            tile.color = Settings.captureTileColor
                            capturingTiles.append(tile)
                            capturingPieces.append(piece)
                        }
                    }

                    mandatoryCaptureLabel.isHidden = !haveMandatoryCaptures
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
        if point.x >= 0 && point.x < CGFloat(dimension) * tileSize &&
            point.y >= 0 && point.y < CGFloat(dimension) * tileSize {
            return (true, Int(point.x / tileSize), Int(point.y / tileSize))
        } else {
            return (false, 0, 0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not used")
    }
}
