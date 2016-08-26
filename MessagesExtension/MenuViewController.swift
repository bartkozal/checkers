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
}

class MenuViewController: UIViewController {
    static let storyboardIdentifier = "MenuViewController"

    weak var delegate: MenuViewControllerDelegate?

    @IBAction private func tapNewGameButton() {
        delegate?.didStartGame()
    }
}
