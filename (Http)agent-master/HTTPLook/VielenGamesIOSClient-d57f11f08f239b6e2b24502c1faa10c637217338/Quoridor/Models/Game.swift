//
//  Game.swift
//  Quoridor
//
//  Created by Konrad Szczesniak on 16/06/14.
//  Copyright (c) 2014 EL Passion. All rights reserved.
//

import Foundation

class Game
{
    let board = Board()
    let player:Player
    let opponent:Player
    
    init(player: Player, opponent: Player)
    {
        self.player = player
        self.opponent = opponent
    }
    
    
}
