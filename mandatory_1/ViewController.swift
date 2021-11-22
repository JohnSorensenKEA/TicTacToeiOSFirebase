//
//  ViewController.swift
//  mandatory_1
//
//  Created by John Sørensen on 26/09/2021.
//

import UIKit

class ViewController: UIViewController {
    
    var gameService = GameService()
    
    @IBOutlet weak var codeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameService.getGamesList()
    }

    @IBAction func startNewGame(_ sender: Any) {
        performSegue(withIdentifier: "ownerSegue", sender: self)
    }
    
    @IBAction func joinGame(_ sender: Any) {
        if gameService.gameExists(id: codeTextField.text ?? "") {
            performSegue(withIdentifier: "joinedSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ownerSegue" {
            if let destination = segue.destination as? OwnerViewController {
                destination.gameService = self.gameService
                destination.gameService?.gameview = destination
            }
        } else {
            if let destination = segue.destination as? JoinedViewController {
                destination.gameService = self.gameService
                destination.gameService?.gameview = destination
                destination.gameService?.docID = codeTextField.text ?? ""
            }
        }
    }
}

