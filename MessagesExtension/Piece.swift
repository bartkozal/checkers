//
//  Piece.swift
//  Checkers
//
//  Created by bkzl on 26/08/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import SpriteKit

enum PieceType: String {
    case pawn, king

    var symbol: String {
        return String(rawValue.characters.first!)
    }

    static func symbol(_ symbol: String) -> PieceType? {
        let symbols: [String: PieceType] = [
            "p": .pawn,
            "k": .king
        ]

        return symbols[symbol]
    }
}

enum PieceSet: String {
    case white, red

    var symbol: String {
        return String(rawValue.characters.first!)
    }

    static func symbol(_ symbol: String) -> PieceSet? {
        let symbols: [String: PieceSet] = [
            "w": .white,
            "r": .red
        ]

        return symbols[symbol]
    }
}

class Piece: CustomStringConvertible, Equatable {
    var column: Int
    var row: Int
    var pieceSet: PieceSet
    var sprite: SKSpriteNode?

    var pieceType: PieceType {
        didSet {
            sprite?.texture = SKTexture(imageNamed: spriteName)
        }
    }

    var spriteName: String {
        return "\(pieceSet)-\(pieceType)"
    }

    var symbol: String {
        return "\(pieceType.symbol)\(pieceSet.symbol)"
    }

    var description: String {
        return "\(pieceSet) \(pieceType), column: \(column), row: \(row)"
    }

    var captureRange: Int {
        switch pieceType {
        case .king:
            return 7
        case .pawn:
            return 1
        }
    }

    init(column: Int, row: Int, pieceType: PieceType, pieceSet: PieceSet) {
        self.column = column
        self.row = row
        self.pieceType = pieceType
        self.pieceSet = pieceSet
    }

    func canMoveTo(column: Int, row: Int) -> Bool {
        switch (pieceType, pieceSet) {
        case (.pawn, .white):
            return self.column + 1 == column && self.row + 1 == row || self.column - 1 == column && self.row + 1 == row
        case (.pawn, .red):
            return self.column + 1 == column && self.row - 1 == row || self.column - 1 == column && self.row - 1 == row
        case (.king, .white), (.king, .red):
            return abs(self.column - column) == abs(self.row - row)
        }
    }

    func canMoveOnCaptureTo(column: Int, row: Int) -> Bool {
        switch pieceType {
        case .pawn:
            return self.column + 2 == column && self.row + 2 == row ||
                   self.column - 2 == column && self.row + 2 == row ||
                   self.column + 2 == column && self.row - 2 == row ||
                   self.column - 2 == column && self.row - 2 == row
        case .king:
            return abs(self.column - column) == abs(self.row - row)
        }
    }

    func canCapturePieceOf(set pieceSet: PieceSet) -> Bool {
        switch self.pieceSet {
        case .white:
            return pieceSet == .red
        case .red:
            return pieceSet == .white
        }
    }

    func canCrownOn(row: Int) -> Bool {
        switch (pieceType, pieceSet) {
        case (.pawn, .white):
            return row == Settings.boardSize - 1
        case (.pawn, .red):
            return row == 0
        default:
            return false
        }
    }

    func crown() {
        self.pieceType = .king
    }
}

func ==(lhs: Piece, rhs: Piece) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}
