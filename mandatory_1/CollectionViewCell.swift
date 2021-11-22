//
//  CollectionViewCell.swift
//  mandatory_1
//
//  Created by John Sørensen on 20/10/2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    func configure(with sign: String) {
        textLabel.text = sign
        backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.00)
    }
}
