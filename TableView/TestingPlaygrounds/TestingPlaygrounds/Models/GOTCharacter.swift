//
//  prouct.swift
//  TestingPlaygrounds
//
//  Created by sachindra pandey on 10/06/14.
/*
 Copyright (c) 2014 threeroots. All rights reserved.
This project has been created for the sole purpose
of serving as a tutorial, and a demo for those interested in learning 'Swift' programming language.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY 'threeroots' `AS IS' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
EVENT SHALL 'threeroots' OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/


import Foundation
import UIKit

class GOTCharacter : NSObject {
    //properties
    var characterName : String?
    var characterDescription : String?
    var characterImageName :String?
    
    //initializers
    /*
    - 2 types 'designated initializer' and 'convenience initializers'
    - Written using the 'init' keyword.
    - Unlike Objective-C initializers, Swift initializers do not return a value.
    - For Deallocation and cleanup use 'Deinitializer' similar to 'dealloc'
    
    3-Rules of initialization
    -Designated initializers must call a designated initializer from their immediate superclass.
    -Convenience initializers must call another initializer available in the same class.
    -Convenience initializers must ultimately end up calling a designated initializer.
    
    */
    //Designate initializers
    init() {
        //- Ensure that all of the properties introduced by its class are initialized before it delegates up to a superclass initializer.
        // No need to write the override keyword when overriding an initializer.
        self.characterName = "[Unnamed]"
        self.characterDescription = "[Undescribed]"
        let picPath = NSBundle.mainBundle().pathForResource("Budha-profile-pic", ofType: "png")
        self.characterImageName = picPath;
        super.init()
        listAllElements();
    }
    
    init(var name:String){
        self.characterName = name
        self.characterDescription = "[Undescribed]"
        let picPath = NSBundle.mainBundle().pathForResource("Budha-profile-pic", ofType: "png")
        self.characterImageName = picPath;
        super.init()
        listAllElements();
    }
    
    //Convenience initializers: secondary supporting initializers for a class.
    convenience init(var name:String,var description:String, var picPath:String?) {
        self.init()

        self.characterName = name
        self.characterDescription = description
        if(picPath){
            self.characterImageName = picPath!;
        }
        else{
            println("pic path missing")
            self.characterImageName = nil
        }
        listAllElements();
    }
    
    //methods
    func listAllElements(){
        println("productName= \(characterName)")
        println("characterDescription= \(characterDescription)")
        println("characterImageName= \(characterImageName)")
    }
}