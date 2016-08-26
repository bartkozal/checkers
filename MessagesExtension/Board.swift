//
//  Board.swift
//  Checkers
//
//  Created by bkzl on 26/08/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import Messages

class Board {
    private var pieces = Array2D<Piece>(columns: Settings.boardSize, rows: Settings.boardSize)

    func pieceAt(column: Int, row: Int) -> Piece? {
        guard column >= 0 && column < Settings.boardSize else { return nil }
        guard row >= 0 && row < Settings.boardSize else { return nil }

        return pieces[column, row]
    }

    func isPieceAt(column: Int, row: Int) -> Bool {
        return pieceAt(column: column, row: row) != nil
    }

    func move(piece: Piece, to: (column: Int, row: Int)) {
        pieces[piece.column, piece.row] = nil
        piece.column = to.column
        piece.row = to.row
        pieces[to.column, to.row] = piece
    }

    init(message: MSMessage?) {
        pieces[0, 0] = Piece(column: 0, row: 0, pieceType: .white)
        pieces[2, 0] = Piece(column: 2, row: 0, pieceType: .white)
        pieces[4, 0] = Piece(column: 4, row: 0, pieceType: .white)
        pieces[6, 0] = Piece(column: 6, row: 0, pieceType: .white)
        pieces[1, 1] = Piece(column: 1, row: 1, pieceType: .white)
        pieces[3, 1] = Piece(column: 3, row: 1, pieceType: .white)
        pieces[5, 1] = Piece(column: 5, row: 1, pieceType: .white)
        pieces[7, 1] = Piece(column: 7, row: 1, pieceType: .white)
        pieces[0, 2] = Piece(column: 0, row: 2, pieceType: .white)
        pieces[2, 2] = Piece(column: 2, row: 2, pieceType: .white)
        pieces[4, 2] = Piece(column: 4, row: 2, pieceType: .white)
        pieces[6, 2] = Piece(column: 6, row: 2, pieceType: .white)
        pieces[1, 5] = Piece(column: 1, row: 5, pieceType: .red)
        pieces[3, 5] = Piece(column: 3, row: 5, pieceType: .red)
        pieces[5, 5] = Piece(column: 5, row: 5, pieceType: .red)
        pieces[7, 5] = Piece(column: 7, row: 5, pieceType: .red)
        pieces[0, 6] = Piece(column: 0, row: 6, pieceType: .red)
        pieces[2, 6] = Piece(column: 2, row: 6, pieceType: .red)
        pieces[4, 6] = Piece(column: 4, row: 6, pieceType: .red)
        pieces[6, 6] = Piece(column: 6, row: 6, pieceType: .red)
        pieces[1, 7] = Piece(column: 1, row: 7, pieceType: .red)
        pieces[3, 7] = Piece(column: 3, row: 7, pieceType: .red)
        pieces[5, 7] = Piece(column: 5, row: 7, pieceType: .red)
        pieces[7, 7] = Piece(column: 7, row: 7, pieceType: .red)
    }
}
