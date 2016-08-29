//
//  Board.swift
//  Checkers
//
//  Created by bkzl on 26/08/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import Messages

class Board {
    private var pieces: Array2D<Piece>!
    private let newGameSetupKey = "pw00,pw20,pw40,pw60,pw11,pw31,pw51,pw71,pw02,pw22,pw42,pw62,pr15,pr35,pr55,pr75,pr06,pr26,pr46,pr66,pr17,pr37,pr57,pr77"
    var initialSetupKey: String!

    var setupKey: String {
        get {
            var setup: [String] = []
            for row in 0..<Settings.boardSize {
                for column in 0..<Settings.boardSize {
                    if let piece = pieces[column, row] {
                        setup.append("\(piece.symbol)\(piece.column)\(piece.row)")
                    }
                }
            }
            return setup.joined(separator: ",")
        }

        set {
            setUpBoard(with: newValue)
        }
    }

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

    func capture(piece: Piece) {
        pieces[piece.column, piece.row] = nil
    }

    init(message: MSMessage?) {
        guard let message = message, let url = message.url else {
            initialSetupKey = newGameSetupKey
            setUpBoard(with: initialSetupKey)
            return
        }

        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            for item in components.queryItems! where item.name == "board" {
                let setupKey = item.value!
                initialSetupKey = setupKey
                setUpBoard(with: initialSetupKey)
            }
        }
    }

    private func setUpBoard(with setup: String) {
        pieces = Array2D<Piece>(columns: Settings.boardSize, rows: Settings.boardSize)

        for piece in setup.components(separatedBy: ",") {
            let setup = Array(piece.characters)
            let pieceType = PieceType.symbol(String(setup[0]))!
            let pieceSet = PieceSet.symbol(String(setup[1]))!
            let column = Int(String(setup[2]))!
            let row = Int(String(setup[3]))!

            pieces[column, row] = Piece(column: column, row: row, pieceType: pieceType, pieceSet: pieceSet)
        }
    }
}
