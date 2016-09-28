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
    func didChangeBackwardJumpsInSequences(to rule: Bool)
    func didChangeMandatoryCapturing(to rule: Bool)
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

    var _backwardJumpsInSequences = Settings.backwardJumpsInSequences
    var backwardJumpsInSequences: Bool {
        get {
            return _backwardJumpsInSequences
        }

        set {
            _backwardJumpsInSequences = newValue
            delegate?.didChangeBackwardJumpsInSequences(to: newValue)
            disableBackwardJumpsInSequencesButton.isEnabled = newValue == true
            enableBackwardJumpsInSequencesButton.isEnabled = newValue == false
        }
    }

    var _mandatoryCapturing = Settings.mandatoryCapturing
    var mandatoryCapturing: Bool {
        get {
            return _mandatoryCapturing
        }

        set {
            _backwardJumpsInSequences = newValue
            delegate?.didChangeMandatoryCapturing(to: newValue)
            disableMandatoryCapturingButton.isEnabled = newValue == true
            enableMandatoryCapturingButton.isEnabled = newValue == false
        }
    }

    weak var delegate: MenuViewControllerDelegate?

    @IBOutlet private weak var smallBoardButton: UIButton! {
        didSet {
            smallBoardButton.isEnabled = boardSize != .small
        }
    }

    @IBOutlet private weak var largeBoardButton: UIButton! {
        didSet {
            largeBoardButton.isEnabled = boardSize != .large
        }
    }

    @IBOutlet private weak var disableBackwardJumpsButton: UIButton! {
        didSet {
            disableBackwardJumpsButton.isEnabled = backwardJumps == true
        }
    }

    @IBOutlet private weak var enableBackwardJumpsButton: UIButton! {
        didSet {
            enableBackwardJumpsButton.isEnabled = backwardJumps == false
        }
    }

    @IBOutlet private weak var disableBackwardJumpsInSequencesButton: UIButton! {
        didSet {
            disableBackwardJumpsInSequencesButton.isEnabled = backwardJumpsInSequences == true
        }
    }

    @IBOutlet private weak var enableBackwardJumpsInSequencesButton: UIButton! {
        didSet {
            enableBackwardJumpsInSequencesButton.isEnabled = backwardJumpsInSequences == false
        }
    }

    @IBOutlet private weak var disableMandatoryCapturingButton: UIButton! {
        didSet {
            disableMandatoryCapturingButton.isEnabled = mandatoryCapturing == true
        }
    }

    @IBOutlet private weak var enableMandatoryCapturingButton: UIButton! {
        didSet {
            enableMandatoryCapturingButton.isEnabled = mandatoryCapturing == false
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

    @IBAction private func tapBackwardJumpsInSequencesButton(button: UIButton) {
        if button.titleLabel?.text == "Yes" {
            backwardJumpsInSequences = true
        } else {
            backwardJumpsInSequences = false
        }
    }

    @IBAction private func tapMandatoryCapturingButton(button: UIButton) {
        if button.titleLabel?.text == "Yes" {
            mandatoryCapturing = true
        } else {
            mandatoryCapturing = false
        }
    }

    @IBAction private func tapNewGameButton() {
        delegate?.didStartGame()
    }
}
