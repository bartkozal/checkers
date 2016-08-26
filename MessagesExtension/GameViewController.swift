//
//  GameViewController.swift
//  Checkers
//
//  Created by bkzl on 26/08/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameViewControllerDelegate: class {
    func didMove(snapshot gameSnapshot: UIImage)
}

class GameViewController: UIViewController {
    static let storyboardIdentifier = "GameViewController"

    weak var delegate: GameViewControllerDelegate?

    var scene: GameScene!
    var board: Board!

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

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = self.view as! SKView
        skView.isMultipleTouchEnabled = false

        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.board = board
        scene.renderBoard()

        skView.presentScene(scene)
    }
}
