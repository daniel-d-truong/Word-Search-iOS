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
    let dim = 10
    let defaultList = ["Swift", "Kotlin", "ObjectiveC", "Variable", "Java", "Mobile"]
    var wordBoard: WordBoard!
    var score = 0

    // Pan Gesture Variables
    var firstIndexPath: IndexPath? = IndexPath()
    var possibleCellsToExplore: [POSITION] = []
    var wordString: String = ""
    var visitedIndexPath: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()

        wordSearchView.delegate = self
        wordSearchView.dataSource = self
        
        self.wordBoard = generateWordSearch(wordsList: defaultList)
    }

    
    @IBAction func tapMakeBoardButton(_ sender: Any) {
        self.reloadWordSearch()
    }
    
    func reloadWordSearch() {
        self.wordBoard = generateWordSearch(wordsList: defaultList, dim: dim)
        self.wordSearchView.reloadData()
    }
    
    func incrementScore() {
        self.score+=1
        self.wordsScore.text = String(self.score)
    }
}

// Collection View Protocols
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wordSearchView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.reuseIdentifier, for: indexPath) as! WordCollectionViewCell
        cell.letterLabel.text = String(self.wordBoard.wordGrid[indexPath.row/dim][indexPath.row%dim])
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Double(self.wordSearchView.bounds.width)/Double(self.dim), height: Double(self.wordSearchView.bounds.height)/Double(self.dim))
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    
    func setupCollectionView() {
        wordSearchView.canCancelContentTouches = false
        wordSearchView.allowsMultipleSelection = true
        
        // Initialize pan gesture recognizer to handle swiping on collectionView
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(toSelectLabelCells:)))
        // limit to one finger
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.minimumNumberOfTouches = 1
        // sets the gestureRecognizer's delegate
        panGestureRecognizer.delegate = self
        wordSearchView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func didPan(toSelectLabelCells panGestureRecognizer: UIPanGestureRecognizer) {
        switch panGestureRecognizer.state {
        case .began:
            self.wordString = ""
            implementDragging(with: panGestureRecognizer)
            break
        case .changed:
            implementDragging(with: panGestureRecognizer)
            break
        case .ended:
            self.visitedIndexPath = []
            if self.wordBoard.wordsList.contains(self.wordString) {
                self.incrementScore()
            }
            break
        default:
            break
        }
    }
    
    func implementDragging(with panGestureRecognizer: UIPanGestureRecognizer) {
        let location = panGestureRecognizer.location(in: self.wordSearchView)
        
        // TODO: Deal with handle erroring later
        let indexPath = self.wordSearchView.indexPathForItem(at: location)!
        if !self.visitedIndexPath.contains(indexPath) {
            self.visitedIndexPath.append(indexPath)
            let cell = self.wordSearchView.cellForItem(at: indexPath) as! WordCollectionViewCell
            self.wordString += cell.letterLabel.text!
            print(wordString)
        }
    }
}
