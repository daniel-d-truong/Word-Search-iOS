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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wordSearchView.delegate = self
        wordSearchView.dataSource = self
        
        self.wordSearchView.isScrollEnabled = false
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
        let cell = wordSearchView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.reuseIdentifier, for: indexPath)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dim = 10
        return CGSize(width: Double(self.wordSearchView.bounds.width)/Double(dim), height: Double(self.wordSearchView.bounds.height)/Double(dim))
    }
}
