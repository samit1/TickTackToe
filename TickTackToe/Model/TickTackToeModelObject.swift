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
    
    case occupied(TickTackToePlayer)
    case unoccupied
    
    
}

struct TickTackToeModelObject {
    
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
    
    mutating func occupyByPlayer(_ player: TickTackToePlayer) {
        occupationState = .occupied(player)
    }
}

extension TickTackToeModelObject : CustomStringConvertible {
    var description: String {
        return "------------\n occupiedBy: \(String(describing: occupationState)) \n row: \(row) \n col: \(col)"
    }
}

extension TickTackToeModelObject : Equatable, Hashable {
    var hashValue: Int {
        return uuid.hashValue
    }
    
    static func == (lhs: TickTackToeModelObject, rhs: TickTackToeModelObject) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
    
}
