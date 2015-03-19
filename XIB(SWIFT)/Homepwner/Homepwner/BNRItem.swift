//
//  BNRItem.swift
//  Homepwner
//
//  Created by Han Kang on 6/10/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit

class BNRItem: NSObject {
    var _itemName:String
    var _serialNumber:String
    var _valueInDollars:Int
    var _dateCreated:NSDate
    var _itemKey:String
    
    init(name:String, dollars:Int, serialNumber:String) {
        self._itemName = name
        self._valueInDollars = dollars
        self._serialNumber = serialNumber
        self._dateCreated = NSDate()
        let uuid = NSUUID()
        self._itemKey = uuid.UUIDString
        super.init()
    }
    class func randomItem() -> BNRItem {
        let randomAdjectiveList = ["Fluffy", "Rusty", "Shiny"]
        let randomNounList = ["Bear", "Tiger", "Mac"]
        var adjectiveIndex = arc4random() % UInt32(randomAdjectiveList.count)
        var nounIndex = arc4random() % UInt32(randomNounList.count)
        var randomAdj = randomAdjectiveList.bridgeToObjectiveC().objectAtIndex(Int(adjectiveIndex)) as NSString
        var randomNoun = randomNounList.bridgeToObjectiveC().objectAtIndex(Int(nounIndex)) as NSString
        var randomName = "\(randomAdj) \(randomNoun)"
        var randomValue = Int(arc4random().toUIntMax() % 100)
        // todo (generate a random serial)
        var randomSerial = "3AB57"
        var newItem = BNRItem(name:randomName,
                              dollars:randomValue,
                              serialNumber:randomSerial)
        return newItem
    }
    var itemKey:String {
        get {
            return _itemKey
        }
        set(itemKey) {
            _itemKey = itemKey
        }
    }
    var itemName:String {
        get {
            return _itemName
        }
        set(itemName) {
            _itemName = itemName
        }
    }
    var serialNumber:String {
        get {
            return _serialNumber
        }
        set(serialNumber) {
            _serialNumber = serialNumber
        }
    }
    var valueInDollars:Int {
        get {
            return _valueInDollars
        }
        set(valueInDollars) {
            _valueInDollars = valueInDollars
        }
    }
    var dateCreated:NSDate {
        get {
            return _dateCreated
        }
        set(dateCreated) {
            _dateCreated = dateCreated
        }
    }
    
    override var description:String {
        get {
            return String(format:"%@ (%@): Worth $%d, recorded on %@",itemName,serialNumber,valueInDollars,dateCreated)
        }
    }
}
