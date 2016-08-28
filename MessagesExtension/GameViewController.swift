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
    func didMove(setup boardSetup: String, snapshot gameSnapshot: UIImage)
}

class GameViewController: UIViewController {
    static let storyboardIdentifier = "GameViewController"

    weak var delegate: GameViewControllerDelegate?

    var scene: GameScene!
    var board: Board!
    var skView: SKView!

    @IBOutlet weak var buttonsView: UIStackView!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!

    @IBAction private func tapConfirmButton() {
        delegate?.didMove(setup: board.setupKey, snapshot: getGameSnapshot())
    }

    @IBAction private func tapUndoButton() {
        board.setupKey = board.initialSetupKey
        scene.renderBoard()
        undoButton.isEnabled = false
        confirmButton.isEnabled = false
        skView.isUserInteractionEnabled = true
    }

    private func getGameSnapshot() -> UIImage {
        let cgImage = skView!.texture(from: scene.gameLayer)!.cgImage()
        return UIImage(cgImage: cgImage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        skView = SKView(frame: view.frame)
        skView.isMultipleTouchEnabled = false
        view.addSubview(skView)
        view.bringSubview(toFront: buttonsView)

        scene = GameScene(size: skView.bounds.size)
        scene.gameSceneDelegate = self
        scene.scaleMode = .aspectFill
        scene.board = board
        scene.renderBoard()

        skView.presentScene(scene)
    }
}

extension GameViewController: GameSceneDelegate {
    func didFinishMove() {
        undoButton.isEnabled = true
        confirmButton.isEnabled = true
        skView.isUserInteractionEnabled = false
    }
}
