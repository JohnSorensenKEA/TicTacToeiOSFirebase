//
//  Game.swift
//  mandatory_1
//
//  Created by John Sørensen on 18/10/2021.
//

import Foundation

class Game {
    
    var gameId: String
    var starter: Bool
    var moves: [Int]
    
    init(gameId: String, starter: Bool, moves: [Int]) {
        self.gameId = gameId
        self.starter = starter
        self.moves = moves
    }
    
    func checkGameState() -> Int{
        //-1 owner win, 0 tie, 1 joined win, 2 continued
        
        var ownerMoves : [Int] = []
        var joinedMoves : [Int] = []
        
        for (index, move) in moves.enumerated() {
            let b = (index%2) == 1
            if (b == starter) {
                ownerMoves.append(move)
            } else {
                joinedMoves.append(move)
            }
        }
        
        var test1 = 0
        test1 += checkHorizontal(moves: ownerMoves)
        test1 += checkVertical(moves: ownerMoves)
        test1 += checkCross(moves: ownerMoves)
        if test1 > 0 {
            return -1
        }
        
        var test2 = 0
        test2 += checkHorizontal(moves: joinedMoves)
        test2 += checkVertical(moves: joinedMoves)
        test2 += checkCross(moves: joinedMoves)
        if test2 > 0 {
            return 1
        }
        
        if checkTie(moves: moves) > 0 {
            return 0
        }
        
        return 2
    }
    
    func checkHorizontal(moves: [Int]) -> Int {
        let checkSet = [[0,1,2], [3,4,5], [6,7,8]]
        return check(moves: moves, checkSet: checkSet)
    }
    
    func checkVertical(moves: [Int]) -> Int {
        let checkSet = [[0,3,6], [1,4,7], [2,5,8]]
        return check(moves: moves, checkSet: checkSet)
    }
    
    func checkCross(moves: [Int]) -> Int {
        let checkSet = [[0,4,8], [2,4,6]]
        return check(moves: moves, checkSet: checkSet)
    }
    
    func checkTie(moves: [Int]) -> Int {
        if moves.count > 8 {
            return 1
        }
        return 0
    }
    
    func check(moves: [Int], checkSet: [[Int]]) -> Int {
        for set in checkSet {
            var success = true
            for i in set {
                if !moves.contains(i) {
                    success = false
                }
            }
            if success {
                return 1
            }
        }
        return 0
    }
}
