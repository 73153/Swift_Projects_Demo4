//
//  Board.swift
//  Hack2048
//
//  Created by Kohei Iwasaki on 2014/06/07.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

import UIKit

class Board: NSObject {
    
    let boardSize = 4               // ボードの１辺のサイズ
    
    var rawBoard = Int[][]()        // 盤面の状態
    var movementBoard = Dictionary<String, AnyObject>[][]() // それぞれの数字が移動する先を保存する配列
    var turn:Int = 0                // 現在のターン数
    var updateLog = Int[][][][]()   // 盤面の履歴 undoなどに用いる
    
    /**
    * 初期化処理
    */
    init(){
        super.init()
        
        for _ in 0..boardSize {
            rawBoard += Int[](count: boardSize, repeatedValue: 0)
            movementBoard += Dictionary<String, AnyObject>[](count:boardSize, repeatedValue:["x":0, "y":0])            
        }
        
    }
    
    /**
    * ゲームの初期化
    */
    func initGame(){
        // 盤面の初期化
        for y in 0..boardSize {
            for x in 0..boardSize {
                rawBoard[y][x] = 0
            }
        }
    }
    
    /**
    * 盤面上を与えられた方角にスワイプ・マージさせる。
    * 成功したらtrue、盤面が何も変わらなければfalseを返す
    */
    func swipeBoard(dir:Direction) -> Bool {
        
        for y in 0..boardSize {
            for x in 0..boardSize {
                movementBoard[y][x] = ["x":x, "y":y]
            }
        }

        for line in 0..boardSize {
            let swipedLine:Dictionary<String, Int>[] = self.swipeLine(line, dir:dir)
            
            // 盤面の更新 と 移動先の更新
            for (idx,num) in enumerate(swipedLine) {
                switch dir {
                case .Right:
                    movementBoard[line][boardSize-1-num["from"]!] = ["x":boardSize-1-num["to"]!, "y":line]
                    rawBoard[line][boardSize-1-idx] = num["num"]!
                case .Left:
                    movementBoard[line][num["from"]!] = ["x":num["to"]!, "y":line]
                    rawBoard[line][idx] = num["num"]!
                case .Up:
                    movementBoard[num["from"]!][line] = ["x":line, "y":num["to"]!]
                    rawBoard[idx][line] = num["num"]!
                case .Down:
                    movementBoard[boardSize-1-num["from"]!][line] = ["x":line, "y":boardSize-1-num["to"]!]
                    rawBoard[boardSize-1-idx][line] = num["num"]!
                }
            }
        }
        for line in 0..boardSize {
            println(movementBoard[line])
            println(rawBoard[line])
        }
        var falseCount = 0
        if falseCount == boardSize { return false }
        
        
        // 少しでも位置が変わっていたらtrueを返す
        for y in 0..boardSize {
            for x in 0..boardSize {
                let pos = movementBoard[y][x] as NSDictionary
                if pos["x"] as Int != x || pos["y"] as Int != y  {
                    
                    // 更新履歴に追加
//                    var copiedBoard = rawBoard.copy()
//                    updateLog += Int[][][](count:1, repeatedValue:copiedBoard)
                    
                    return true
                }
            }
        }
        
        // 全くかわっていなければfalseを返す
        return false
        
    }
    
    /**
    * 盤面上の１つの行または列に含まれる数字を与えられた方角にスワイプ・マージさせる。
    */
    func swipeLine(line:Int, dir:Direction) -> Dictionary<String, Int>[] {
        
        // 数字と、元の位置を持つ変数
        var numbers = Dictionary<String, Int>[]()
        
        // 行または列内の数値を取得
        // dirの向きに応じた並び順にする。
        for i in 0..boardSize {
            switch dir {
            case .Right:
                numbers += ["num":rawBoard[line][boardSize-1-i], "from":i, "to":i]
            case .Left:
                numbers += ["num":rawBoard[line][i], "from":i, "to":i]
            case .Up:
                numbers += ["num":rawBoard[i][line], "from":i, "to":i]
            case .Down:
                numbers += ["num":rawBoard[boardSize-1-i][line], "from":i, "to":i]
            }
        }
        
        // 0以外の数字を前にスライドさせる 0202 -> 2200
        var num = 0
        while num < boardSize-1 {
            if(numbers[num]["num"] == 0 && numbers[num+1]["num"] > 0){
                numbers[num+1]["to"] = num
                let tempNum = numbers[num+1]
                numbers[num+1] = numbers[num]
                numbers[num] = tempNum
                num = 0
            }else{
                ++num
            }
        }
        
        // 隣り合う２つの数字が同値なら合体させる。ただし２連続では合体させない。 2200 -> 4000
        var i = 0
        while(i < numbers.count - 1){
            if(numbers[i]["num"] == numbers[i+1]["num"] && numbers[i]["num"] != 0){
                numbers[i]["num"] = numbers[i]["num"]! * 2
                numbers[i]["to"] = i
                numbers[i+1]["num"] = 0
                numbers[i+1]["to"] = i
                ++i
            }
            ++i
        }
        
        // 合体の際に0が発生した可能性があるので、もう一度０以外の数字を前にスライドさせる
        num = 0
        while num < boardSize-1 {
            if(numbers[num]["num"] == 0 && numbers[num+1]["num"] > 0){
                if(num+2 < boardSize && numbers[num+1]["to"] == numbers[num+2]["to"]){
                    // 2連続で合体していた場合のアニメーションの対処
                    numbers[num+2]["to"] = num
                }
                numbers[num+1]["to"] = num
                let tempNum = numbers[num+1]
                numbers[num+1] = numbers[num]
                numbers[num] = tempNum
                num = 0
            }else{
                ++num
            }
        }
        
        // 結果を返す
        return numbers
        
    }
    
    /**
    * 盤面の空いている箇所を取得する
    */
    func getEmptyPositions() -> Int[]{
        var results = Int[]()
        
        // yとかxは勝手にletされる（宣言いらない）
        for y in 0..boardSize {
            for x in 0..boardSize {
                if(rawBoard[y][x] == 0){
                    results += y*boardSize + x
                }
            }
        }
        return results;
    }
    
    /**
    * 盤面の空いている箇所からランダムに1カ所選択し、「2」を代入する。
    */
    func generateNumber() -> NSDictionary{
        let empties:Int[] = self.getEmptyPositions()
        
        // arc4random()を使って記述すると何故か落ちる。
        let randomPos = empties[Int(arc4random_uniform(UInt32(empties.count)))]
        let y = randomPos / boardSize
        let x = randomPos % boardSize
        rawBoard[y][x] = 2
        
        return ["x": x, "y": y]
//        var copiedBoard = rawBoard.copy()
//        updateLog += Int[][][](count:1, repeatedValue:copiedBoard)
    }
    
    /**
    * 盤面を１ターン前の状態に戻す
    */
    func undo(){
        if(turn > 0){
            rawBoard = self.updateLog[turn-1][0].copy()
            self.updateLog.removeAtIndex(turn)
        }
    }
    
    /**
    * 盤面が全て埋まっていて、スワイプしても何も変わらない場合、ゲームオーバー
    */
    func isGameOver() -> Bool{
        
        // 盤面が埋まっていなかったら、false
        for y in 0..boardSize {
            for x in 0..boardSize {
                if(rawBoard[y][x] == 0){
                    return false
                }
            }
        }
        
        // スワイプできるようであれば、false
        for dir in [Direction.Right, Direction.Up]{
            if(swipeBoard(dir)){
                self.undo()   // 実際にスワイプしてしまっては困るのでundoする
                return false
            }
        }
        
        // ゲームオーバー
        return true
        
    }
    
}