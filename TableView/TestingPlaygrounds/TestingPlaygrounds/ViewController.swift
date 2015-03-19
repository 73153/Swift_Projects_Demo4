
//
//  ViewController.swift
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

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //declare all the properties
    var gotCharactersArray: AnyObject? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //loading an array from a file
        var documentList=NSBundle.mainBundle().pathForResource("GOTCharacters", ofType:"plist")
        gotCharactersArray = NSArray(contentsOfFile:documentList);
        println(" \(__FUNCTION__)Fetching 'GOTCharacters.plist 'file \n \(gotCharactersArray) \n")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    //TableView Delegates and Datasources
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        //NSArray
        println("number of rows= \((gotCharactersArray as NSArray).count)")
        return (gotCharactersArray as NSArray).count
        
        
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        let aCell=tableView.dequeueReusableCellWithIdentifier("GOTCharacterTableViewCell", forIndexPath: indexPath) as GOTCharacterTableViewCell
        aCell.tag=indexPath.row;
        
        var aCharacter: NSDictionary = (gotCharactersArray?[indexPath.row] as NSDictionary)
        
        var gotCharacter : GOTCharacter = GOTCharacter(name: aCharacter["name"] as String, description: aCharacter["description"] as String, picPath: aCharacter["image"] as? String)
        aCell.setCharacter(gotCharacter)

        return aCell
    }

    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        println("ViewController\(__FUNCTION__) YES YES YES  description=\(segue.description) identifier=\(segue.identifier) sender: \(sender)")
        
        let cell = sender as? GOTCharacterTableViewCell
        let index = cell!.tag
        
        let detailViewController: DetailViewController = segue.destinationViewController as DetailViewController;

        var aCharacter: NSDictionary = (gotCharactersArray?[index] as NSDictionary)
        let name : AnyObject! = aCharacter["name"];
        let description : AnyObject! = aCharacter["description"]
        let picPath : AnyObject! = aCharacter["image"]
        
        println("name \(name)")
        println("description \(description)")
        println("picPath \(picPath)")
        var gotCharacter : AnyObject! = GOTCharacter(name: name! as String, description: description! as String, picPath: picPath! as? String)
        
        detailViewController.setCharacter(gotCharacter as GOTCharacter)
    }
}

