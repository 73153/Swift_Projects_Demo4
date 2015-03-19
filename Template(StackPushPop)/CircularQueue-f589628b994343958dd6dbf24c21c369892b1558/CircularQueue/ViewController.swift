//
//  ViewController.swift
//  CircularQueue
//
//  Created by Andrew Hulsizer on 6/6/14.
//  Copyright (c) 2014 Tastemade. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var queue = CircularQueue<String>(bufferSize: 10)
    var elements = 0
    
    @IBAction func addNewElement() {
        queue.push("\(elements)")
        ++elements
        printQueue()
    }
    
    @IBAction func popOldestElement() {
        let item = queue.pop()
        println("popped element: \(item)")
        printQueue()
    }
    
    func printQueue() {
        for element in queue {
            println(element)
        }
        println("-----------------------------------")
        println("")
    }
}
