//
//  GameViewController.swift
//  Hack2048
//
//  Created by Kohei Iwasaki on 2014/06/06.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

import UIKit

enum Direction {
    case Right, Left, Up, Down
}

// タイル
class Tile: UILabel {
    
    let marginX:CGFloat = APP_SIZE.width  * 0.1
    let marginY:CGFloat = APP_SIZE.height * 0.2
    let labelSize:CGFloat = APP_SIZE.width  * 0.2
    
    init(pos:(Int, Int), bgColor:UIColor) {
        super.init(frame: CGRectZero)
        
        let posX = labelSize * CGFloat(pos.0) + marginX
        let posY = labelSize * CGFloat(pos.1) + marginY
        self.frame = CGRectMake(posX, posY, labelSize, labelSize)

        self.backgroundColor = bgColor
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.textAlignment = .Center
    }
    
    func moveTo(pos:(Int, Int)){
        frame = CGRectMake(
            labelSize * CGFloat(pos.0) + marginX,
            labelSize * CGFloat(pos.1) + marginY,
            self.frame.size.width,
            self.frame.size.height
        )
    }
}

class GameViewController: UIViewController {
    
    let board = Board()
    
    let bgColors = [
        0: 0xbcbc00,
        2: 0xffffff,
        4: 0x4444cc,
        8: 0xdd3333,
        16: 0xdd3399,
        32: 0x993399,
        64: 0x4833dd,
        128: 0x226622,
        256: 0x66ff33
    ]
    
    var tiles = Tile[]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for y in 0..board.boardSize {
            for x in 0..board.boardSize {
                // 背景の配置
                let bgTile = Tile(pos:(x,y), bgColor:RGBA(bgColors[0]!, 1.0))
                self.view.addSubview(bgTile)
                
                // タイルの配置
                let tile = Tile(pos:(x,y), bgColor:RGBA(bgColors[0]!, 1.0))
                self.view.addSubview(tile)
                tiles += tile
            }
        }
        
        // スワイプジェスチャーの追加
        let dirs:UISwipeGestureRecognizerDirection[] = [.Right, .Left, .Up, .Down]
        for dir in dirs{
            let sgr = UISwipeGestureRecognizer(target: self, action: Selector("swiped:"))
            sgr.direction = dir
            self.view.addGestureRecognizer(sgr)
        }
        
        self.updateStatus()
        
    }
    
    /*
    * Handle Swip Gesture
    */
    func swiped(sender: UISwipeGestureRecognizer){
        
        var dir:Direction = .Right
        if(sender.direction.value == UISwipeGestureRecognizerDirection.Right.value){
            dir = .Right
        }else if(sender.direction.value == UISwipeGestureRecognizerDirection.Left.value){
            dir = .Left
        }else if(sender.direction.value == UISwipeGestureRecognizerDirection.Up.value){
            dir = .Up
        }else if(sender.direction.value == UISwipeGestureRecognizerDirection.Down.value){
            dir = .Down
        }
        
        if board.swipeBoard(dir) {
            ++board.turn
            self.updateStatus()
        }
        
    }
    
    func updateStatus(){
        
        // 0以外は移動
        for y in 0..board.boardSize {
            for x in 0..board.boardSize {
                let idx:Int = y * board.boardSize + x
                
                let label = tiles[idx]
                let text = label.text
                
                if(!text || text == ""){ continue }
                
                let pos = board.movementBoard[y][x] as NSDictionary
                
                let posX = pos["x"]! as Int
                let posY = pos["y"]! as Int
                
                if posX != x || posY != y {
                    
                    
                    
                    self.view.bringSubviewToFront(self.tiles[idx])
                    
                    UIView.animateWithDuration(0.5, animations:
                        { () in
                            self.tiles[idx].moveTo((posX, posY))
                        }, completion: {(Bool) in })
                    
                }
                
            }
        }
        
        // 2を出す
        let gPos = board.generateNumber()
        let x:Int = gPos["x"] as Int
        let y:Int = gPos["y"] as Int
        let idx:Int = y * board.boardSize + x
        
        // 1秒後に描画
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.40, target: self, selector: Selector("updateScreen:"), userInfo: idx, repeats: false)
        
        ++board.turn
        
    }
    
    func updateScreen(timer:NSTimer){
        
        // 場所を正しくする
        for y in 0..board.boardSize {
            for x in 0..board.boardSize {
                let idx:Int = y * board.boardSize + x
                tiles[idx].moveTo((x,y))
            }
        }
        
        for y in 0..board.boardSize {
            for x in 0..board.boardSize {
                let idx:Int = y * board.boardSize + x
                let num:Int = board.rawBoard[y][x]
                if(num > 0){
                    tiles[idx].text = String(num)
                }else{
                    tiles[idx].text = ""
                }
                tiles[idx].backgroundColor = RGBA(bgColors[num]!, 1.0)
            }
        }
        let idx:Int = timer.userInfo as Int
        tiles[idx].text = "2"
        tiles[idx].backgroundColor = RGBA(bgColors[2]!, 1.0)
    }
    
}
