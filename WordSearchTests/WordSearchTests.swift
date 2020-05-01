//
//  WordSearchTests.swift
//  WordSearchTests
//
//  Created by Daniel Truong on 4/29/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import XCTest
@testable import WordSearch

class WordSearchTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWordsOnBoardExist() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        for _ in 0..<2 {
            let wordList = ["Swift", "Kotlin", "ObjectiveC", "Variable", "Java", "Mobile"].map({ $0.lowercased() })
            let board = generateWordSearch(wordsList: wordList, dim: 10)
            
            // Run the test about 10 times
            print(board.wordGrid)
            for word in wordList {
                let metaData = board.wordPosition[word]
                let pos = metaData!.0
                let dir = metaData!.1
                
                for (i, c) in word.enumerated() {
                    XCTAssertEqual(board.wordGrid[i*dir.0 + pos.0][i*dir.1 + pos.1], c)
                }
            }
        }
    }
    
    func testGenerateBoard() {
        let board = WordBoard(dim: 8, wordsList: ["yeet", "code", "ronak", "shopify", "is", "the", "best", "uwu"])

        self.measure {
            board.generateRandomBoard()
        }
    }

}
