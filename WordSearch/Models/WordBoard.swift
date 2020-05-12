//
//  WordBoard.swift
//  WordSearch
//
//  Created by Daniel Truong on 4/30/20.
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

var DIRECTIONS_LIST = [WordDirections.RIGHT, WordDirections.LEFT, WordDirections.UP, WordDirections.DOWN, WordDirections.UP_RIGHT, WordDirections.UP_LEFT, WordDirections.DOWN_LEFT, WordDirections.DOWN_RIGHT]

typealias DIRECTION = (Int, Int)
typealias POSITION = (Int, Int)

class WordBoard {
    let NONE_DIR = (0, 0)
    let NONE_POS = (-1, -1)
    
    var wordsList: [String]
    var wordGrid: [[Character]]
    var dim: Int
    var wordPosition: [String: (POSITION, DIRECTION)]
    var wordPosCount: [[Int]]
    
    var wordsFound: [String]
    
    init(dim: Int, wordsList: [String]) {
        self.wordsList = wordsList.map({ $0.lowercased() })
        self.wordGrid = [[Character]](repeating: [Character](repeating: "_", count: dim), count: dim)
        self.dim = dim
        self.wordPosition = [:]
        self.wordsFound = []
        self.wordPosCount = [[Int]](repeating: [Int](repeating: 0, count: dim), count: dim)
        
        
        for word in self.wordsList {
            wordPosition[word] = (NONE_POS, NONE_DIR)
        }
    }
    
    func positionOf(word: String) -> (POSITION, DIRECTION) {
        return self.wordPosition[word] ?? ((-1, -1), (-1, -1))
    }
    
    func generateWordSearch() -> Bool {
        // Resets the board
        self.wordGrid = [[Character]](repeating: [Character](repeating: "_", count: dim), count: dim)
        
        var wordIndex = 0
        while wordIndex < wordsList.count {
            print("iteration \(wordIndex)")
            if wordIndex < 0 {
                return false
            }
            if wordIndex == 0 {
                self.wordsList.shuffle()
            }
            let currWord = self.wordsList[wordIndex]
            // Takes out word from the grid
            
            let prevPosition = self.positionOf(word: currWord).0
            let prevDir = self.positionOf(word: currWord).1
            
            if prevPosition != NONE_POS && prevDir != NONE_DIR {
                for (i,_) in currWord.enumerated() {
                    let x = i*prevDir.0 + prevPosition.0
                    let y = i*prevDir.1 + prevPosition.1
                    self.wordPosCount[x][y]-=1
                    if self.wordPosCount[x][y] == 0 {
                        self.wordGrid[x][y] = "_"
                    }
                }
//                print(self.wordPosition[currWord])
//                print(self.wordGrid)
                self.wordPosition[currWord] = (NONE_POS, NONE_DIR)
            }
            
            let listOfChoices: [Int] = (0..<dim).filter{ $0 - currWord.count > 0 || $0 + currWord.count <= dim }

            let randomNum = listOfChoices.randomElement()!
            let randomPos1 = (randomNum, (0..<dim).randomElement()!)
            let randomPos2 = ((0..<dim).randomElement()!, randomNum)
            let randomPos = [randomPos1, randomPos2].randomElement()!
                
            DIRECTIONS_LIST.shuffle()
            for dir in DIRECTIONS_LIST {
                    // Check that the word can go this direction.
                if self.posWithinBounds(randomPos, dir, currWord: currWord) {
                    for (i, c) in currWord.enumerated() {
                        let x = i*dir.0 + randomPos.0
                        let y = i*dir.1 + randomPos.1
                        self.wordGrid[x][y] = c
                        self.wordPosCount[x][y]+=1
                        // TODO: Logic to indicate that the word has been visited
                    }
                    self.wordPosition[currWord] = (randomPos, dir)
                    wordIndex+=1
                    break
                }
            }
    
            // Reaching this point indicates that none of the directions work
            if self.positionOf(word: currWord).0 == NONE_POS {
                wordIndex-=1
            }
        }
        print(self.wordPosition)
//        print(self.wordGrid)
        return true
    }
    
    func fillBoard() {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        for (i, row) in self.wordGrid.enumerated() {
            for (j, char) in row.enumerated() {
                self.wordGrid[i][j] = char == "_" ? alphabet.randomElement()! : char
            }
        }
    }
    
    func generateRandomBoard() -> Bool {
        let result = generateWordSearch()
        fillBoard()
        return result
    }
    
    func posWithinBounds(_ pos: POSITION, _ dir: DIRECTION, currWord: String) -> Bool {
        let boundedPos = (pos.0 + dir.0*currWord.count, pos.1 + dir.1*currWord.count)
        print(boundedPos)
        
        // Returns False if Out of Bounds
        if boundedPos.0 < 0 || boundedPos.0 > dim || boundedPos.1 < 0 || boundedPos.1 > dim {
            return false
        }
        
        // Checks if any letters are in the way
        for (i, c) in currWord.enumerated() {
            let currChar = self.wordGrid[i*dir.0 + pos.0][i*dir.1 + pos.1]
            if currChar != "_" && currChar != c {
                return false
            }
        }
        return true
    }
}
