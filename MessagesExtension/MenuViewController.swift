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
}

class MenuViewController: UIViewController {
    static let storyboardIdentifier = "MenuViewController"

    var _boardType: BoardType = Settings.boardType
    var boardType: BoardType {
        get {
            return _boardType
        }

        set {
            _boardType = newValue
            Settings.boardType = newValue
            smallBoardButton.isEnabled = newValue != .small
            largeBoardButton.isEnabled = newValue != .large
        }
    }

    weak var delegate: MenuViewControllerDelegate?

    @IBOutlet weak private var smallBoardButton: UIButton! {
        didSet {
            smallBoardButton.isEnabled = boardType != .small
        }
    }

    @IBOutlet weak private var largeBoardButton: UIButton! {
        didSet {
            largeBoardButton.isEnabled = boardType != .large
        }
    }

    @IBAction private func tapBoardTypeButton(button: UIButton) {
        if button.titleLabel?.text == "8x8" {
            boardType = .small
        } else {
            boardType = .large
        }
    }

    @IBAction private func tapNewGameButton() {
        delegate?.didStartGame()
    }
}
