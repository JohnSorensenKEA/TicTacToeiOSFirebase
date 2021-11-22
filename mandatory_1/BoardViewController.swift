//
//  BoardViewController.swift
//  mandatory_1
//
//  Created by John Sørensen on 20/10/2021.
//

import UIKit

class BoardViewController: UIViewController {

    var game: Game? = nil
    var gameview: GameviewInt? = nil
    var data : [String]? = nil
    
    @IBOutlet weak var collectionView: CollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.boardController = self
        collectionView.items = data ?? []
        collectionView.reloadData()
    }
    
    func update(data: [String]) {
        self.data = data
        collectionView.updateData(data: data)
    }
    
    func newCellSelected(index: Int) {
        gameview?.newMove(index: index)
    }
    
}
