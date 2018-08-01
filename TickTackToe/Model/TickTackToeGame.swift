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
    
    enum PlayerUp {
        case player1Up(TickTackToePlayer)
        case player2Up(TickTackToePlayer)
    }

    /// First player of the game
    private (set) var player1: TickTackToePlayer
    
    /// Second player of the game
    private (set) var player2: TickTackToePlayer
    
    /// Game is a nxn matrix. The game is specifically a 3x3 matrix
    private var n = 3
    
    /// The player who owns the next move
    private (set) var playerUp: PlayerUp
    
    /// Initializes a new game
    init(player1: TickTackToePlayer, player2: TickTackToePlayer) {
        self.player1 = player1
        self.player2 = player2
        playerUp = PlayerUp.player1Up(player1)
        newGame()
    }
    
    /// Convenience initialization - begins the game with a player1 and player2
    convenience init() {
        self.init(player1: TickTackToePlayer(playerType: .player1), player2: TickTackToePlayer(playerType: .player2))
    }
    
    /// Game is a nxn grid, represented as an array of arrays
    private (set) var tickTackToeGrid = [[TickTackToeModelObject]]()
    
    /// The delegate responsible for what to do with a result of a match
    weak var matchDelegate : MatchResultDelegate?
    
    /// Begin a new game
    func newGame() {
        tickTackToeGrid.removeAll()
        for row in 0..<n {
            tickTackToeGrid.append([TickTackToeModelObject]())
            for col in 0..<n {
                tickTackToeGrid[row].append(TickTackToeModelObject(row: row, col: col))
            }
        }
    }
    
    /// Handles what to do when a player selects a TickTackToe object
    func selected(by player: TickTackToePlayer, atRow: Int, atCol: Int) {
        guard tickTackToeGrid.indices.contains(atRow), tickTackToeGrid[0].indices.contains(atCol) else {
            return
        }
        
        tickTackToeGrid[atRow][atCol].occupyByPlayer(player)
        switchPlayerUp()
        determineIfWinner()
    }
    
    /// Getter method to retrieve an individual TickTackToe object. Method safely checks for out of bounds conditions and returns nil if an object does not exist.
    func getTickTackToe(forRow: Int, forCol: Int) -> TickTackToeModelObject? {
        guard tickTackToeGrid.indices.contains(forRow), tickTackToeGrid[0].indices.contains(forCol)  else {return nil}
        
        return tickTackToeGrid[forRow][forCol]
    }
    
    /// Determine if there is a winner for the game
    /// Each time this method is called, the delegate is notified of the `MatchResult`
    private func determineIfWinner() {
        
        /// Check rows of tickTackToeGrid for a winner
        for row in tickTackToeGrid {
            var tickTackToes = [TickTackToeModelObject]()
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
            var tickTackToes = [TickTackToeModelObject]()
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
        
        var diagonalObjects = [TickTackToeModelObject]()
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
    
    /// Helper method to determine whether all grid objects are occupied
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
    
    /// Determines if there is a winning player
    private func determineWinningPlayer(tickTackToes: [TickTackToeModelObject]) -> Player? {
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
    private func switchPlayerUp() {
        switch playerUp {
        case .player1Up(_):
            playerUp = .player2Up(player2)
        case .player2Up(_):
            playerUp = .player1Up(player1)
        }
    }
    
    private func setPlayers(player1Name: String, player2Name: String) {
        let player1 = TickTackToePlayer(playerType: .player1)
        player1.name = player1Name
        
        let player2 = TickTackToePlayer(playerType: .player2)
        player2.name = player1Name
        
        self.player1 = player1
        self.player2 = player2
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


