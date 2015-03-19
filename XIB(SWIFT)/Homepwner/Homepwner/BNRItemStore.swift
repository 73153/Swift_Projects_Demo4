//
//  BNRItemStore.swift
//  Homepwner
//
//  Created by Han Kang on 6/10/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit

class BNRItemStore: NSObject {
    var allItems = BNRItem[]()
    class var items:NSArray {
        get {
            return NSArray(array:BNRItemStore.sharedStore.allItems)
        }
    }
    class var sharedStore:BNRItemStore {
        return GlobalItemStore
    }
    class var count:Int {
        get {
            return self.items.count
        }
    }
    func createItem() -> BNRItem {
        var item = BNRItem.randomItem()
        self.allItems.append(item)
        return item
    }
    func removeItem(item:BNRItem) {
        BNRImageStore.sharedStore.deleteImageForKey(item.itemKey)
        let index = BNRItemStore.items.indexOfObject(item)
        self.allItems.removeAtIndex(index)
    }
    func moveItemAtIndex(fromIndex: Int, toIndex:Int) {
        if fromIndex == toIndex {
            return
        }
        let item = self.allItems[fromIndex]
        self.allItems.removeAtIndex(fromIndex)
        self.allItems.insert(item, atIndex:toIndex)
    }
}

let GlobalItemStore = BNRItemStore()