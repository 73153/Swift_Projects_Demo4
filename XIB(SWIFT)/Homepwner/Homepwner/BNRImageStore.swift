//
//  BNRImageStore.swift
//  Homepwner
//
//  Created by Han Kang on 6/11/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit

class BNRImageStore: NSObject {
    var dictionary:NSMutableDictionary

    class var sharedStore:BNRImageStore {
        return GlobalImageStore
    }
    init() {
        self.dictionary = NSMutableDictionary()
        super.init()
    }
    func setImage(image:UIImage,forKey key:String) {
        self.dictionary.setValue(image, forKey:key)
    }
    func imageForKey(key:String) -> UIImage? {
        return self.dictionary.objectForKey(key) as? UIImage
    }
    func deleteImageForKey(key:String?) {
        if !key {
            return
        }
        self.dictionary.removeObjectForKey(key!)
    }
}

let GlobalImageStore = BNRImageStore()