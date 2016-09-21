//
//  GameViewController.swift
//  Checkers
//
//  Created by bkzl on 26/08/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import SpriteKit
import StoreKit

protocol GameViewControllerDelegate: class {
    func didFinishMove(setupValue: String, activePieceSetValue: String, snapshot gameSnapshot: UIImage)
}

class GameViewController: UIViewController {
    static let storyboardIdentifier = "GameViewController"

    weak var delegate: GameViewControllerDelegate?

    var scene: GameScene!
    var board: Board!
    var skView: SKView!
    var transactionInProgress = false {
        didSet {
            if transactionInProgress {
                donationButton.isEnabled = false
                transactionIndicator.startAnimating()
            } else {
                donationButton.isEnabled = true
                transactionIndicator.stopAnimating()
            }
        }
    }

    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var donationButton: UIButton! {
        didSet {
            donationButton.isHidden = !SKPaymentQueue.canMakePayments()
        }
    }
    @IBOutlet weak var transactionIndicator: UIActivityIndicatorView! {
        didSet {
            transactionIndicator.stopAnimating()
        }
    }

    @IBAction func tapDonationButton() {
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(self)

            transactionInProgress = true

            let productRequest = SKProductsRequest(productIdentifiers: Set(["bkzl.checkers.iap.coffee"]))
            productRequest.delegate = self
            productRequest.start()
        }
    }

    func getGameSnapshot() -> UIImage {
        let cgImage = skView!.texture(from: scene.gameLayer)!.cgImage()
        return UIImage(cgImage: cgImage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        skView = SKView(frame: view.frame)
        skView.isMultipleTouchEnabled = false
        view.addSubview(skView)

        scene = GameScene(size: skView.bounds.size)
        scene.gameSceneDelegate = self
        scene.scaleMode = .aspectFill
        scene.board = board
        scene.renderBoard()

        skView.presentScene(scene)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        SKPaymentQueue.default().remove(self)
    }

    override func viewDidLayoutSubviews() {
        skView.frame = boardView.frame
    }
}

extension GameViewController: GameSceneDelegate {
    func didFinishMove() {
        delegate?.didFinishMove(setupValue: board.setupValue, activePieceSetValue: board.activePieceSetValue, snapshot: getGameSnapshot())
    }
}

extension GameViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
}

extension GameViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transcation in transactions {
            switch transcation.transactionState {
            case .purchased, .failed, .restored:
                SKPaymentQueue.default().finishTransaction(transcation)
                transactionInProgress = false
            default:
                break
            }
        }
    }
}
