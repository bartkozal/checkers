//
//  Piece.swift
//  Checkers
//
//  Created by bkzl on 26/08/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import SpriteKit

enum PieceType: Int {
    case white, red, whiteKing, redKing

    var spriteName: String {
        let spriteNames = ["white-piece", "red-piece", "white-king", "red-king"]

        return spriteNames[rawValue]
    }

    var symbol: String {
        let symbols = ["w", "r", "wk", "rk"]

        return symbols[rawValue]
    }

    static func bySymbol(_ symbol: String) -> PieceType? {
        let symbols: [String: PieceType] = [
            "w": .white,
            "r": .red,
            "wk": .whiteKing,
            "rk": .redKing
        ]
        
        return symbols[symbol]
    }
}

class Piece {
    var column: Int
    var row: Int
    var pieceType: PieceType {
        didSet {
            sprite?.texture = SKTexture(imageNamed: pieceType.spriteName)
        }
    }

    var sprite: SKSpriteNode?

    init(column: Int, row: Int, pieceType: PieceType) {
        self.column = column
        self.row = row
        self.pieceType = pieceType
    }

    func canMoveTo(column: Int, row: Int) -> Bool {
        switch pieceType {
        case .white:
            return self.column + 1 == column && self.row + 1 == row || self.column - 1 == column && self.row + 1 == row
        case .red:
            return self.column + 1 == column && self.row - 1 == row || self.column - 1 == column && self.row - 1 == row
        case .whiteKing, .redKing:
            return abs(self.column - column) == abs(self.row - row)
        }
    }

    func canCrownOn(row: Int) -> Bool {
        switch pieceType {
        case .white:
            return row == Settings.boardSize - 1
        case .red:
            return row == 0
        default:
            return false
        }
    }
}
