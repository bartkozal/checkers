import Foundation

enum BoardSize: String {
    case small
    case large

    var dimension: Int {
        switch self {
        case .small:
            return 8
        case .large:
            return 10
        }
    }

    var newGameSetup: String {
        switch self {
        case .small:
            return "pw00,pw20,pw40,pw60,pw11,pw31,pw51,pw71,pw02,pw22,pw42,pw62,pr15,pr35,pr55,pr75,pr06,pr26,pr46,pr66,pr17,pr37,pr57,pr77"
        case .large:
            return "pw00,pw20,pw40,pw60,pw80,pw11,pw31,pw51,pw71,pw91,pw02,pw22,pw42,pw62,pw82,pr17,pr37,pr57,pr77,pr97,pr08,pr28,pr48,pr68,pr88,pr19,pr39,pr59,pr79,pr99"
        }
    }

    var symbol: String {
        return String(rawValue.characters.first!)
    }

    static func symbol(_ symbol: String) -> BoardSize? {
        let symbols: [String: BoardSize] = [
            "s": .small,
            "l": .large
        ]

        return symbols[symbol]
    }
}
