//
//  TickTackToeGame.swift
//  TickTackToe
//
//  Created by Sami Taha on 7/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import Foundation

protocol MatchResultDelegate : class {
    func matchConcluded(result: MatchResult)
}

enum MatchResult {
    case won(Player)
    case resultTBD
    case noWinnerGameOver
}

class TickTackToeGame {
    
    /// First player of the game
    private (set) var player1: Player
    
    /// Second player of the game
    private (set) var player2: Player
    
    /// Game is a nxn matrix. The game is specifically a 3x3 matrix
    private var n = 3
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
        newGame()
    }
    
    /// Game is a nxbn grid, represented as an array of arrays
    private (set) var tickTackToeGrid = [[TickTackToeGridObject]]()
    
    /// The delegate responsible for what to do with a result of a match
    weak var matchDelegate : MatchResultDelegate?
    
    /// Begin a new game
    func newGame() {
        tickTackToeGrid.removeAll()
        for row in 0..<n {
            tickTackToeGrid.append([TickTackToeGridObject]())
            for col in 0..<n {
                tickTackToeGrid[row].append(TickTackToeGridObject(row: row, col: col))
            }
        }
        print(tickTackToeGrid)
    }
    
    
    func selected(by player: Player, at row: Int, at col: Int) {
        guard tickTackToeGrid.indices.contains(row), tickTackToeGrid[0].indices.contains(col) else {
            return
        }
        
        tickTackToeGrid[row][col].occupyByPlayer(player)
        determineIfWinner()
    }
    
    private func determineIfWinner() {

        
        /// Check rows of tickTackToeGrid for a winner
        for row in tickTackToeGrid {
            var tickTackToes = [TickTackToeGridObject]()
            for col in row {
                tickTackToes.append(col)
            }
            
            /// If winner found, report and exit
            if let winner = determineWinningPlayer(tickTackToes: tickTackToes) {
                matchDelegate?.matchConcluded(result: .won(winner))
                return
            }
        }
        
        /// Check columns of tickTackToeGrid for a winner
        for col in 0..<n {
            var tickTackToes = [TickTackToeGridObject]()
            for row in 0..<n {
                tickTackToes.append(tickTackToeGrid[row][col])
            }
            
            /// If winner found, report and exit
            if let winner = determineWinningPlayer(tickTackToes: tickTackToes) {
                matchDelegate?.matchConcluded(result: .won(winner))
                return
            }
        }
        
        /// Check LXR diagonals of tickTackToeGrid for a winner
        var row = 0
        var col = 0
        
        var diagonalObjects = [TickTackToeGridObject]()
        while row < n && col < n {
            diagonalObjects.append(tickTackToeGrid[row][col])
            row += 1
            col += 1
        }
        
        /// If winner found, report and exit
        if let winner = determineWinningPlayer(tickTackToes: diagonalObjects) {
            matchDelegate?.matchConcluded(result: .won(winner))
            return
        }
        
        row = 0
        col = 0
        diagonalObjects.removeAll()
        
        /// Check RXL diagonals of tickTackToeGrid for a winner
        while row < n && col >= 0 {
            diagonalObjects.append(tickTackToeGrid[row][col])
            row += 1
            col -= 1
        }
        
        /// If winner found, report and exit
        if let winner = determineWinningPlayer(tickTackToes: diagonalObjects) {
            matchDelegate?.matchConcluded(result: .won(winner))
            return
        }
        
        /// If no winner is found, check if all grid spaces are occupied
        if fullyOccupied() {
            /// If all are occupied and no winner was found then game is over and there is no winner
            matchDelegate?.matchConcluded(result: .noWinnerGameOver)
        } else {
            /// Otherwise the results are still pending
            matchDelegate?.matchConcluded(result: .resultTBD)
        }
    }
    
    private func fullyOccupied() -> Bool {
        
        var occupiedCount = 0
        for row in tickTackToeGrid {
            for col in row {
                switch col.occupationState {
                case .occupied(_):
                    occupiedCount += 1
                case .unoccupied:
                    continue
                }
            }
        }
        
        return occupiedCount == n * n
    }
    
 
    private func determineWinningPlayer(tickTackToes: [TickTackToeGridObject]) -> Player? {
        var players = Set<Player>()
        var winningPlayer : Player?
        for tickTackToe in tickTackToes {
            switch tickTackToe.occupationState {
            case .occupied(let player):
                /// Insert the player to players Set
                players.insert(player)
                /// Temporarily set the player as a winner
                winningPlayer = player
            case .unoccupied:
                /// If a space is unoccupied it is impossible for there to be a winner
                return nil
            }
        }
        
        if players.count == 1 {
            /// If only one item exists in the set then it must be the winner
            return winningPlayer
        } else {
            /// If here, then there is more than 1 player occupying n spaces, which means we cannot possible have a winner for this set of TickTackToeGridObjects
            return nil
        }
    }
    
}
 /*
     0.  1.  2.
0.   x |   | O
1.   O | X | O
2.   X | X | O

 
 0,0   0,2
 1,1   1,1
 2,2   2,0
 
 */


