//
//  GameProposalService.swift
//  Quoridor
//
//  Created by Konrad Szczesniak on 16/06/14.
//  Copyright (c) 2014 EL Passion. All rights reserved.
//

import Foundation

class GameProposalService
{
    func fetchGameProposals(completion: (gameProposals:NSArray) -> (Void))
    {
        NetworkManager().request(NetworkManagerMethodGET,
            path: "game_proposals",
            parameters: nil,
            successClosure: { (response:AnyObject!) in
                
            },
            errorClosure: { (response:AnyObject!, error:NSError) in
                
            })
        
    }
}
