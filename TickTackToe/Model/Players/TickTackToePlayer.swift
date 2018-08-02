//
//  TickTackToePlayer.swift
//  TickTackToe
//
//  Created by Sami Taha on 8/1/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import Foundation

enum TickTackToePlayerType : String {
    case player1
    case player2
}

class TickTackToePlayer : Player {
    var playerType: TickTackToePlayerType
    
    init(playerType: TickTackToePlayerType) {
        self.playerType = playerType
        super.init(name: playerType.rawValue)
    }
}

extension TickTackToePlayer : CustomStringConvertible {
    var description : String {
        return playerType.rawValue
    }
}

