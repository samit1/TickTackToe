//
//  TickTackToeGridObject.swift
//  TickTackToe
//
//  Created by Sami Taha on 7/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import Foundation

enum TickTackToeState : Hashable {
    var hashValue: Int {
        return self.hashValue
    }
    
    case occupied(Player)
    case unoccupied
    
    
}

struct TickTackToeGridObject {
    
    /// Tick tack toe object can be occupied by a player
    private (set) var occupationState = TickTackToeState.unoccupied
    
    /// Tick tack toe object's cooresponding row position
    private (set) var row : Int
    
    /// Tick tack toe object's cooresponding column position
    private (set) var col: Int
    
    /// UUID
    private (set) var uuid = NSUUID().uuidString
    
    init(row: Int, col: Int ) {
        self.row = row
        self.col = col
    }
    
    mutating func occupyByPlayer(_ player: Player) {
        occupationState = .occupied(player)
    }
}

extension TickTackToeGridObject : CustomStringConvertible {
    var description: String {
        return "------------\n occupiedBy: \(String(describing: occupationState)) \n row: \(row) \n col: \(col)"
    }
}

extension TickTackToeGridObject : Equatable, Hashable {
    var hashValue: Int {
        return uuid.hashValue
    }
    
    static func == (lhs: TickTackToeGridObject, rhs: TickTackToeGridObject) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
    
}