//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by bkzl on 26/08/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Messages
import SpriteKit

class MessagesViewController: MSMessagesAppViewController {
    var controller = UIViewController()
    var boardSize = BoardSize.small {
        didSet {
            Settings.boardSize = boardSize
        }
    }
    var backwardJumps = false {
        didSet {
            Settings.backwardJumps = backwardJumps
        }
    }

    var backwardJumpsInSequences = true {
        didSet {
            Settings.backwardJumpsInSequences = backwardJumpsInSequences
        }
    }

    var mandatoryCapturing = true {
        didSet {
            Settings.mandatoryCapturing = mandatoryCapturing
        }
    }

    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)

        presentVC(for: conversation, with: presentationStyle)
    }

    override func didBecomeActive(with conversation: MSConversation) {
        super.didBecomeActive(with: conversation)

        guard let message = conversation.selectedMessage else { return }

        if controller.isMember(of: GameViewController.self) {
            let isSenderSameAsRecipient = message.senderParticipantIdentifier == conversation.localParticipantIdentifier
            (controller as? GameViewController)?.scene.isUserInteractionEnabled = !isSenderSameAsRecipient
        }
    }

    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        guard let conversation = activeConversation else {
            fatalError("Expected the active conversation")
        }

        presentVC(for: conversation, with: presentationStyle)
    }

    private func presentVC(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        if presentationStyle == .compact {
            controller = instantiateMenuVC()
        } else {
            let board = Board(message: conversation.selectedMessage)
            controller = instantiateGameVC(with: board)
        }

        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }

        addChildViewController(controller)
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)

        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        controller.didMove(toParentViewController: self)
    }

    private func instantiateMenuVC() -> UIViewController {
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: MenuViewController.storyboardIdentifier) as? MenuViewController else {
            fatalError("Can't instantiate MenuViewController")
        }

        menuVC.delegate = self

        return menuVC
    }

    private func instantiateGameVC(with board: Board) -> UIViewController {
        guard let gameVC = storyboard?.instantiateViewController(withIdentifier: GameViewController.storyboardIdentifier) as? GameViewController else {
            fatalError("Can't instantiate GameViewController")
        }

        gameVC.board = board
        gameVC.delegate = self

        return gameVC
    }
}

extension MessagesViewController: MenuViewControllerDelegate {
    func didChangeBoardSize(to size: BoardSize) {
        boardSize = size
    }

    func didChangeBackwardJumps(to rule: Bool) {
        backwardJumps = rule
    }

    func didChangeBackwardJumpsInSequences(to rule: Bool) {
        backwardJumpsInSequences = rule
    }

    func didChangeMandatoryCapturing(to rule: Bool) {
        mandatoryCapturing = rule
    }

    func didStartGame() {
        requestPresentationStyle(.expanded)
    }
}

extension MessagesViewController: GameViewControllerDelegate {
    func didFinishMove(setupValue: String,
                       boardSizeValue: String,
                       activePieceSetValue: String,
                       backwardJumpsValue: String,
                       backwardJumpsInSequencesValue: String,
                       mandatoryCapturingValue: String,
                       snapshot gameSnapshot: UIImage) {
        dismiss()

        let conversation = activeConversation
        let session = conversation?.selectedMessage?.session ?? MSSession()

        let layout = MSMessageTemplateLayout()
        layout.image = gameSnapshot

        var components = URLComponents()
        let setupQueryItem = URLQueryItem(name: "board", value: setupValue)
        let boardSizeQueryItem = URLQueryItem(name: "size", value: boardSizeValue)
        let activePieceSetQueryItem = URLQueryItem(name: "set", value: activePieceSetValue)
        let backwardJumpsQueryItem = URLQueryItem(name: "jumps", value: backwardJumpsValue)
        let backwardJumpsInSequencesQueryItem = URLQueryItem(name: "sequences", value: backwardJumpsInSequencesValue)
        let mandatoryCapturingQueryItem = URLQueryItem(name: "capturing", value: mandatoryCapturingValue)
        components.queryItems = [setupQueryItem, boardSizeQueryItem, activePieceSetQueryItem, backwardJumpsQueryItem, backwardJumpsInSequencesQueryItem, mandatoryCapturingQueryItem]

        let message = MSMessage(session: session)
        message.layout = layout
        message.url = components.url
        message.summaryText = "Did a move in Checkers."
        
        conversation?.insert(message)
    }
}
