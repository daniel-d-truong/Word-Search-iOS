//
//  WordCollectionViewCell.swift
//  WordSearch
//
//  Created by Daniel Truong on 4/29/20.
//  Copyright © 2020 Daniel Truong. All rights reserved.
//

import UIKit

class WordCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "WordCell"
    var color: UIColor = .blue
    @IBOutlet weak var letterLabel: UILabel!
    
    func setColor(color: UIColor) {
        self.color = color
        self.backgroundColor = color
    }
}
