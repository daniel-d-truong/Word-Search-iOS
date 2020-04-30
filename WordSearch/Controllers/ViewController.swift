//
//  ViewController.swift
//  WordSearch
//
//  Created by Daniel Truong on 4/29/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// Collection View representing the Word Search Board
    @IBOutlet weak var wordSearchView: UICollectionView!
    
    /// Label to display number of words found
    @IBOutlet weak var wordsScore: UILabel!
    var wordGrid: [[String]] = []
    let dim = 10
    let defaultList = ["Swift", "Kotlin", "ObjectiveC", "Variable", "Java", "Mobile"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wordSearchView.delegate = self
        wordSearchView.dataSource = self
        
        self.wordSearchView.isScrollEnabled = false
        
        self.wordGrid = generateWordSearch(wordsList: defaultList)
    }

    
    @IBAction func tapMakeBoardButton(_ sender: Any) {
    }
    
}

// Collection View Protocols
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wordSearchView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.reuseIdentifier, for: indexPath) as! WordCollectionViewCell
        cell.letterLabel.text = self.wordGrid[indexPath.row/dim][indexPath.row%dim]
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Double(self.wordSearchView.bounds.width)/Double(self.dim), height: Double(self.wordSearchView.bounds.height)/Double(self.dim))
    }
}
