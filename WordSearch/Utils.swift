//
//  Utils.swift
//  WordSearch
//
//  Created by Daniel Truong on 4/29/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import Foundation

/// Represents steps to take in both directions
struct WordDirections {
    static let RIGHT = (1, 0)
    static let LEFT = (-1, 0)
    static let UP = (0, 1)
    static let DOWN = (0, -1)
    static let UP_RIGHT = (1, 1)
    static let UP_LEFT = (-1, 1)
    static let DOWN_RIGHT = (1, -1)
    static let DOWN_LEFT = (-1, -1)
}

func generateWordSearch(_ wordsList: [String], dim: Int = 10) {
//    var wordGrid: [[String]] = [[String]](repeating: [String](repeating: "_", count: dim), count: dim)
//    var positionsUsed: [(Int, Int)] =
    
    // TODO: Word search generator logic.
}
