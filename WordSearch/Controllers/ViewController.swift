//
//  ViewController.swift
//  WordSearch
//
//  Created by Daniel Truong on 4/29/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import UIKit
import TagListView
import LBConfettiView
import PopupDialog

class ViewController: UIViewController {

    // Collection View representing the Word Search Board
    @IBOutlet weak var wordSearchView: UICollectionView!
    
    // Label to display number of words found
    @IBOutlet weak var wordsScore: UILabel!
    
    let dim = 10
    let defaultList = ["Swift", "Kotlin", "ObjectiveC", "Variable", "Java", "Mobile"]
    var wordBoard: WordBoard!
    var score = 0
    var confettiView: ConfettiView!
    @IBOutlet weak var wordsView: TagListView!
    
    // Pan Gesture Variables
    var firstIndexPath: IndexPath? = IndexPath()
    var possibleCellsToExplore: [POSITION] = []
    var wordString: String = ""
    var visitedIndexPath: [IndexPath] = []
    var wordMap: [String: TagView]!
    var wordColors: [String: UIColor]!
    
    // Word Search Positions
    var initialPosition: IndexPath!
    var cellsList: [WordCollectionViewCell] = []
    var previousCell: IndexPath!
    var currentDirection: DIRECTION!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()

        wordSearchView.delegate = self
        wordSearchView.dataSource = self
        
        self.wordsView.alignment = .center
        
        self.confettiView = ConfettiView(frame: self.view.bounds)
        view.addSubview(confettiView)
        
        self.reloadWordSearch()
    }

    
    @IBAction func tapMakeBoardButton(_ sender: Any) {
        self.reloadWordSearch()
    }
    
    func reloadWordSearch() {
        self.wordBoard = generateWordSearch(wordsList: defaultList, dim: dim)
        self.wordsView.removeAllTags()
        self.wordMap = [:]
        self.wordColors = [:]
        self.wordsScore.text = "0"
        
        for i in 0..<10 {
            let word = self.wordBoard.wordsList[i]
            self.wordMap[word] = self.wordsView.addTag(word)
        }
        
        self.confettiView.stop()
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
        cell.setColor(color: .blue)
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
            // Reset all the used fields
            self.visitedIndexPath = []
            if self.wordBoard.wordsList.contains(self.wordString) && !self.wordBoard.wordsFound.contains(self.wordString) {
                self.incrementScore()
                self.wordBoard.wordsFound.append(self.wordString)
                
                self.wordColors[self.wordString] = UIColor.random()
    
                
                self.resetAllCellsColor(color: self.wordColors[self.wordString]!)
                self.wordMap[self.wordString]?.backgroundColor = self.wordColors[self.wordString]
            } else if self.wordBoard.wordsFound.contains(self.wordString) {
                self.resetAllCellsColor(color: self.wordColors[self.wordString]!)
            } else {
                self.resetAllCellsColor()
            }
            
            self.cellsList = []
            
            self.initialPosition = nil
            self.previousCell = nil
            self.currentDirection = nil
            
            // Check if all words are found
            if self.wordBoard.wordsFound.count == 1 {
                self.confettiView.start()
                let popup = PopupDialog(title: "Congrats!", message: "You have solved this word search!")
                let generateBoardButton = DefaultButton(title: "Generate New Word Search", action: {
                    self.reloadWordSearch()
                })
                popup.addButton(generateBoardButton)
                self.present(popup, animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
    
    func implementDragging(with panGestureRecognizer: UIPanGestureRecognizer) {
        let location = panGestureRecognizer.location(in: self.wordSearchView)
        
        // TODO: Deal with handle erroring later
        let indexPath = self.wordSearchView.indexPathForItem(at: location) ?? nil
        
        if indexPath != nil && !self.visitedIndexPath.contains(indexPath!) && self.sameDirection(indexPath!) {
            self.visitedIndexPath.append(indexPath!)
            
            // Cell Information
            let cell = self.wordSearchView.cellForItem(at: indexPath!) as! WordCollectionViewCell
            self.wordString += cell.letterLabel.text!
            
            if self.cellsList.contains(cell) {
                cell.backgroundColor = .blue
                self.cellsList.removeAll(where: { $0 == cell })
            } else {
                cell.backgroundColor = .red
                self.cellsList.append(cell)
            }
            self.previousCell = indexPath
        }
    }
    
    func resetAllCellsColor(color: UIColor = .blue) {
        for cell in self.cellsList {
            if color != .blue {
                cell.setColor(color: color)
            }
            cell.backgroundColor = cell.color
        }
    }
    
    func sameDirection(_ indexPath: IndexPath) -> Bool {
        guard let _ = self.initialPosition else {
            self.initialPosition = indexPath
            return true
        }
        
        if self.currentDirection == nil {
            calculateDirection(indexPath)
        }
        
        let coordsCurrent = (indexPath.row/dim, indexPath.row%dim)
        let coordsInitial = (self.initialPosition.row/dim, self.initialPosition.row%dim)
        let coordsPrev = (self.previousCell!.row/dim, self.previousCell!.row%dim)
            
        if (self.currentDirection.0 + coordsPrev.0, self.currentDirection.1 + coordsPrev.1) == coordsCurrent {
            return true
        }
        
        if (coordsCurrent == coordsInitial) {
            self.currentDirection = nil
            return true
        }
        
        return false
    }
    
    func calculateDirection(_ indexPath: IndexPath) {
        let coordsInitial = (self.initialPosition.row/dim, self.initialPosition.row%dim)
        let coordsCurrent = (indexPath.row/dim, indexPath.row%dim)
        
        let slope = (coordsCurrent.0 - coordsInitial.0, coordsCurrent.1 - coordsInitial.1)
        self.currentDirection = slope
    }
}
