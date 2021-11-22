//
//  OwnerViewController.swift
//  mandatory_1
//
//  Created by John Sørensen on 01/10/2021.
//

import UIKit

class OwnerViewController: UIViewController, GameviewInt {
    
    enum Segues {
        static let boardSegue = "OwnerBoardSegue"
    }
    
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var codeTextView: UILabel!
    @IBOutlet weak var selector: UISegmentedControl!
    @IBOutlet weak var messageLabel: UILabel!
    
    var gameService : GameService? = nil
    var currentGame : Game? = nil
    var boardView : BoardViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameService?.newGame()
    }
    
    func setWinnerMessage(res: Int) {
        var txt = ""
        
        switch res {
        case -1:
            txt = "HOST WINS"
            break
            
        case 0:
            txt = "TIE GAME"
            break
            
        case 1:
            txt = "GUEST WINS"
            break
            
        default:
            txt = ""
        }
        
        messageLabel.text = txt
    }
    
    @IBAction func endGame(_ sender: Any) {
        gameService?.endGame()
        self.dismiss(animated: true)
    }
    
    @IBAction func resetGame(_ sender: Any) {
        gameService?.resetGame(game: currentGame!)
    }
    
    @IBAction func changeSides(_ sender: Any) {
        gameService?.changeSide(game: currentGame!)
    }
    
    func update(game: Game) {
        currentGame = game
        if game.starter {
            selector.selectedSegmentIndex = 1
        } else {
            selector.selectedSegmentIndex = 0
        }
        codeTextView.text = game.gameId
        boardView?.update(data: dataSourceFormatting(sourceInt: game.moves))
        setWinnerMessage(res: (currentGame?.checkGameState())!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.boardSegue {
            let destVC = segue.destination as! BoardViewController
            destVC.game = self.currentGame
            destVC.gameview = self
            self.boardView = destVC
            destVC.data = dataSourceFormatting(sourceInt: self.currentGame?.moves ?? [])
        }
    }
    
    func dataSourceFormatting(sourceInt: [Int]) -> [String] {
        var data = Array(repeating: "", count: 9)
        for (index, num) in sourceInt.enumerated() {
            let sign = (index%2 == 0 ? "O" : "X")
            data[num] = sign
        }
        return data
    }
    
    func newMove(index: Int) {
        if (currentGame?.moves.count)! > 8 {
            return
        }
        var check = -1
        if currentGame!.starter {
            check = 1
        } else {
            check = 0
        }
        
        if ((currentGame?.moves.count)!%2) == check {
            currentGame?.moves.append(index)
            gameService?.newPlay(game: currentGame!)
        }
    }
}
