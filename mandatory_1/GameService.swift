//
//  GameService.swift
//  mandatory_1
//
//  Created by John Sørensen on 01/10/2021.
//

import Foundation
import Firebase
import FirebaseFirestore

class GameService {
    
    let db = Firestore.firestore()
    let gamesKey = "tictactoe"
    let selKey = "selector"
    let gaKey = "game"
    var docID = ""
    var gameview : GameviewInt? = nil
    var listener : ListenerRegistration? = nil
    var backupGame : Game? = nil
    let viewController : ViewController? = nil
    var gameIdList : [String] = []
    
    func activateGame() {
        listener = db.collection(gamesKey).document(docID).addSnapshotListener { documentSnapshot, error    in if let e = error {
                print("Failed getting document '\(self.docID)': \(String(describing: e))")
            } else {
                if let document = documentSnapshot {
                    let selStr = (document.data()?[self.selKey]) as! String
                    let selInt = Int(selStr)
                    let sel = (selInt == 0) ? false : true
                    let moves = document.data()?[self.gaKey] as! String
                    let movesArrStr = moves.components(separatedBy: ";")
                    
                    var movesArr : [Int] = []
                    
                    for move in movesArrStr {
                        if Int(move) != nil {
                            movesArr.append(Int(move) ?? -1)
                        }
                    }
                    
                    let game = Game(gameId: self.docID, starter: sel, moves: movesArr)
                    self.gameview?.update(game: game)
                    self.backupGame = game
                }
            }
        }
    }
    
    func getGamesList() {
        self.gameIdList.removeAll()
        db.collection(gamesKey).addSnapshotListener { querySnapshot, error    in if let e = error {
                print("Failed getting document ids: \(String(describing: e))")
            } else {
                for doc in querySnapshot!.documents {
                    self.gameIdList.append(doc.documentID)
                }
            }
        }
    }
    
    func getNewGameId() -> String{
        var res = ""
        let signs = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        for _ in 1...5 {
            let random = Int.random(in: 0..<signs.count)
            let index = signs.index(_: signs.startIndex, offsetBy: random)
            res.append(signs[index])
        }
        if gameExists(id: res) {
            res = getNewGameId()
        }
        
        return res
    }
    
    func getGame() -> Game {
        return (backupGame)!
    }
    
    func resetGame(game: Game) {
        let document = db.collection(gamesKey).document(docID)
        let data = [gaKey: "", selKey: game.starter ? "1" : "0"] as [String : Any]
        document.setData(data)
    }
    
    func changeSide(game: Game) {
        game.starter = !game.starter
        resetGame(game: game)
    }
    
    func endGame() {
        db.collection(gamesKey).document(docID).delete()
        docID = ""
        leaveGame()
    }
    
    func newGame() {
        docID = getNewGameId()
        let document = db.collection(gamesKey).document(docID)
        let data = [gaKey: "", selKey: "0"]
        document.setData(data)
        activateGame()
    }
    
    func newPlay(game: Game) {
        let document = db.collection(gamesKey).document(docID)
        let data = [gaKey: game.moves.map( {String($0)} ).joined(separator: ";"), selKey: game.starter ? "1" : "0"] as [String : Any]
        document.setData(data)
    }
    
    func gameExists(id: String) -> Bool{
        return gameIdList.contains(id)
    }
    
    func setGameview(view: GameviewInt) {
        gameview = view
    }
    
    func leaveGame() {
        listener?.remove()
    }
    
    func joinGame(id: String) {
        docID = id
        activateGame()
    }
}
