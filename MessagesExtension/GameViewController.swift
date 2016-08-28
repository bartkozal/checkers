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

    @IBOutlet weak var confirmMoveButton: UIButton!

    @IBAction private func tapConfirmMoveButton() {
        delegate?.didMove(setup: board.setupKey, snapshot: getGameSnapshot())
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
        view.bringSubview(toFront: confirmMoveButton)

        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.board = board
        scene.renderBoard()

        skView.presentScene(scene)
    }
}
