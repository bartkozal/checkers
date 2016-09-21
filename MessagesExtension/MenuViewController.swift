//
//  MenuViewController.swift
//  Checkers
//
//  Created by bkzl on 26/08/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func didStartGame()
    func didChangeBoardSize(to size: BoardSize)
}

class MenuViewController: UIViewController {
    static let storyboardIdentifier = "MenuViewController"

    var _boardSize: BoardSize = Settings.boardSize
    var boardSize: BoardSize {
        get {
            return _boardSize
        }

        set {
            _boardSize = newValue
            delegate?.didChangeBoardSize(to: newValue)
            smallBoardButton.isEnabled = newValue != .small
            largeBoardButton.isEnabled = newValue != .large
        }
    }

    weak var delegate: MenuViewControllerDelegate?

    @IBOutlet weak private var smallBoardButton: UIButton! {
        didSet {
            smallBoardButton.isEnabled = boardSize != .small
        }
    }

    @IBOutlet weak private var largeBoardButton: UIButton! {
        didSet {
            largeBoardButton.isEnabled = boardSize != .large
        }
    }

    @IBAction private func tapBoardSizeButton(button: UIButton) {
        if button.titleLabel?.text == "8x8" {
            boardSize = .small
        } else {
            boardSize = .large
        }
    }

    @IBAction private func tapNewGameButton() {
        delegate?.didStartGame()
    }
}
