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
    func didChangeBackwardJumps(to rule: Bool)
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

    var _backwardJumps: Bool = Settings.backwardJumps
    var backwardJumps: Bool {
        get {
            return _backwardJumps
        }

        set {
            _backwardJumps = newValue
            delegate?.didChangeBackwardJumps(to: newValue)
            disableBackwardJumpsButton.isEnabled = newValue == true
            enableBackwardJumpsButton.isEnabled = newValue == false
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

    @IBOutlet weak var disableBackwardJumpsButton: UIButton! {
        didSet {
            disableBackwardJumpsButton.isEnabled = backwardJumps == true
        }
    }

    @IBOutlet weak var enableBackwardJumpsButton: UIButton! {
        didSet {
            enableBackwardJumpsButton.isEnabled = backwardJumps == false
        }
    }

    @IBAction private func tapBoardSizeButton(button: UIButton) {
        if button.titleLabel?.text == "8x8" {
            boardSize = .small
        } else {
            boardSize = .large
        }
    }

    @IBAction private func tapBackwardJumpsButton(button: UIButton) {
        if button.titleLabel?.text == "Yes" {
            backwardJumps = true
        } else {
            backwardJumps = false
        }
    }

    @IBAction private func tapNewGameButton() {
        delegate?.didStartGame()
    }
}
