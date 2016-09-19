//
//  BoardType.swift
//  Checkers
//
//  Created by bkzl on 19/09/2016.
//  Copyright © 2016 bkzl. All rights reserved.
//

import Foundation

enum BoardType {
    case small
    case large

    var size: Int {
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
}
