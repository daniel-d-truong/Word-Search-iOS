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
    }

    
    @IBAction func tapMakeBoardButton(_ sender: Any) {
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wordSearchView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.reuseIdentifier, for: indexPath)
        return cell
    }
}
