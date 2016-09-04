//
//  RoundedButton.swift
//  Checkers
//
//  Created by bkzl on 04/09/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    let brandColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.0)
    let disabledColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setStyles()
    }

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = brandColor
                layer.borderWidth = 0
            } else {
                backgroundColor = .white
                layer.borderWidth = 1
            }
        }
    }

    private func setStyles() {
        layer.cornerRadius = 8.0
        layer.borderColor = disabledColor.cgColor

        setTitleColor(.white, for: .normal)
        setTitleColor(disabledColor, for: .disabled)

        if isEnabled {
            backgroundColor = brandColor
        } else {
            backgroundColor = .white
            layer.borderWidth = 1
        }

        contentEdgeInsets = UIEdgeInsetsMake(12, 16, 12, 16)
    }
}
