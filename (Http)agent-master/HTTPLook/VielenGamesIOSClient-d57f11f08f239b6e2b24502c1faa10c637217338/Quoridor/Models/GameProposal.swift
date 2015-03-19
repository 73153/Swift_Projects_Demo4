//
//  GameProposal.swift
//  Quoridor
//
//  Created by Konrad Szczesniak on 16/06/14.
//  Copyright (c) 2014 EL Passion. All rights reserved.
//

import Foundation

class GameProposal
{
    let creator:Player
    let id:String
    
    init(id:String, creator:Player)
    {
        self.creator = creator
        self.id = id
    }
}
