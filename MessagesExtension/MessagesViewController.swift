//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by bkzl on 26/08/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)

        presentVC(for: conversation, with: presentationStyle)
    }

    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        guard let conversation = activeConversation else {
            fatalError("Expected the active conversation")
        }

        presentVC(for: conversation, with: presentationStyle)
    }

    private func presentVC(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        let controller: UIViewController

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
    func didStartGame() {
        requestPresentationStyle(.expanded)
    }
}

extension MessagesViewController: GameViewControllerDelegate {
    func didMove(snapshot gameSnapshot: UIImage) {
        requestPresentationStyle(.compact)

        let conversation = activeConversation
        let session = conversation?.selectedMessage?.session ?? MSSession()

        let layout = MSMessageTemplateLayout()
        layout.image = gameSnapshot

        let message = MSMessage(session: session)
        message.layout = layout
        message.summaryText = "Did make a move"
        
        conversation?.insert(message)
    }
}
