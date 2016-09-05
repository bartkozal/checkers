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
    func didMove(setupValue: String, pieceSetValue: String, snapshot gameSnapshot: UIImage)
    func didLoadSpriteKit(view: SKView)
}

class GameViewController: UIViewController {
    static let storyboardIdentifier = "GameViewController"

    weak var delegate: GameViewControllerDelegate?

    var scene: GameScene!
    var board: Board!
    var skView: SKView!

    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var buttonsView: UIStackView!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!

    @IBAction private func tapConfirmButton() {
        delegate?.didMove(setupValue: board.setupValue, pieceSetValue: board.pieceSetValue, snapshot: getGameSnapshot())
    }

    @IBAction private func tapUndoButton() {
        board.setup = board.undoToSetup
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
        delegate?.didLoadSpriteKit(view: skView)
        view.addSubview(skView)

        scene = GameScene(size: skView.bounds.size)
        scene.gameSceneDelegate = self
        scene.scaleMode = .aspectFill
        scene.board = board
        scene.renderBoard()

        skView.presentScene(scene)
    }

    override func viewWillLayoutSubviews() {
        let horizontalSC = traitCollection.horizontalSizeClass
        let verticalSC = traitCollection.verticalSizeClass

        guard verticalSC == .compact && (horizontalSC == .compact || horizontalSC == .regular) else {
            buttonsView.insertArrangedSubview(buttonsView.subviews[0], at: 0)
            return
        }

        buttonsView.insertArrangedSubview(buttonsView.subviews[1], at: 0)
    }

    override func viewDidLayoutSubviews() {
        skView.frame = boardView.frame
    }
}

extension GameViewController: GameSceneDelegate {
    func didFinishMove() {
        undoButton.isEnabled = true
        confirmButton.isEnabled = true
        skView.isUserInteractionEnabled = false
    }
}
