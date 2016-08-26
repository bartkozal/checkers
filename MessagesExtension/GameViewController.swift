//
//  GameViewController.swift
//  Checkers
//
//  Created by bkzl on 26/08/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

protocol GameViewControllerDelegate: class {
    func didMove(snapshot gameSnapshot: UIImage)
}

class GameViewController: UIViewController {
    static let storyboardIdentifier = "GameViewController"

    weak var delegate: GameViewControllerDelegate?

    // var board: Board?

    @IBAction private func tapConfirmMoveButton() {
        delegate?.didMove(snapshot: getGameSnapshot() ?? UIImage())
    }

    private func getGameSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
    }

    // override func viewWillAppear(_ animated: Bool) {
    //     super.viewWillAppear(animated)
    //
    //     board?.view = boardView
    // }
}
