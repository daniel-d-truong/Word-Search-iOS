//
//  Utils.swift
//  WordSearch
//
//  Created by Daniel Truong on 4/29/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import Foundation

let maxWords = 10

/// Recursive method that keeps getting words from the API until we get all appropriate words in the array (length must be less than dimension).
func getRandomWords(_ numWordsLeft:Int, dim: Int, semaphore: DispatchSemaphore, appendRandomWord: @escaping (String) -> Int) {
    if numWordsLeft == 0 {
        semaphore.signal()
        return
    }
    var component = URLComponents(string: "https://random-word-api.herokuapp.com/word")
    component?.queryItems = [URLQueryItem(name: "number", value: String(numWordsLeft))]
    
    var request = URLRequest(url: (component?.url)!)

    // Specify HTTP Method to use
    request.httpMethod = "GET"
    
    // Send HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        // Check if Error took place
        if let error = error {
            print("Error took place \(error)")
            return
        }
                
        // Read HTTP Response Status code
        if let response = response as? HTTPURLResponse {
            print("Response HTTP Status code: \(response.statusCode)")
        }
        
        // Convert HTTP Response Data to a simple String
        guard let data = data else {
            return
        }
        
        // Casting and cleaning the data string
        var dataString = String(data: data, encoding: .utf8)
        dataString?.removeFirst()
        dataString?.removeLast()
        dataString = dataString?.replacingOccurrences(of: "\"", with: "")
        
        // Convert data string to array of strings
        let randomWords = dataString?.components(separatedBy: ",")
        
        var wordsLeft = numWordsLeft
        for word in randomWords! {
            wordsLeft = appendRandomWord(word)
        }
        getRandomWords(wordsLeft, dim: dim, semaphore: semaphore, appendRandomWord: appendRandomWord)
    }
    task.resume()
}

func generateWordSearch(wordsList: [String] = [], dim: Int = 10) -> WordBoard {
    // Dealing with async await
    let semaphore = DispatchSemaphore(value: 0)
    let queue = DispatchQueue.global()
    
    var wordGrid: [[String]] = [[String]](repeating: [String](repeating: "_", count: dim), count: dim)
    var randomWords = wordsList
    
    /// Declare the escaped function in here. Returns how many words are left to be added.
    func appendRandomWord(word: String) -> Int {
        if word.count <= dim && randomWords.count < maxWords {
            randomWords.append(word)
        }
        return maxWords - randomWords.count
    }
    
    queue.async {
        getRandomWords(maxWords-wordsList.count, dim: dim, semaphore: semaphore, appendRandomWord: appendRandomWord)
    }
    semaphore.wait()
        
    // TODO: Word search generator logic.
    let board = WordBoard(dim: dim, wordsList: randomWords)
    while !board.generateRandomBoard() {
    }
    return board
}
