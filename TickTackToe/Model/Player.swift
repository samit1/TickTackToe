//
//  Player.swift
//  TickTackToe
//
//  Created by Sami Taha on 7/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import Foundation

struct Player {
    private (set) var name : String!
    private (set) var uuid = NSUUID().uuidString
    
    init(name: String) {
        self.name = name 
    }
}


extension Player : Equatable, Hashable {
    var hashValue: Int {
        return uuid.hashValue
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    
}
