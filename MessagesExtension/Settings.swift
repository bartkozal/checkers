import UIKit

struct Settings {
    static let darkTilesColor = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1.0)
    static let lightTilesColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    static let lastMoveTileColor = UIColor(red: 0.49, green: 0.83, blue: 0.13, alpha: 1.0)
    static let captureTileColor = UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1.0)

    static var boardSize = BoardSize.small
    static var mandatoryCapturing = true
    static var backwardJumps = false
    static var backwardJumpsInSequences = true
}
