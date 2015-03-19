//
//  DetailViewController.swift
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

class DetailViewController: UIViewController {

    @IBOutlet var detailImageView : UIImageView
    @IBOutlet var descriptionTextView : UITextView
    var gotCharacter : GOTCharacter?
    
//    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        // Custom initialization
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        println("\(__FUNCTION__)")
        // Do any additional setup after loading the view.
        if(self.gotCharacter){
            detailImageView.image = UIImage(named: self.gotCharacter!.characterImageName)
            descriptionTextView.text = self.gotCharacter!.characterDescription
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue ){
    
    }
    
    func setCharacter(character: GOTCharacter){
        println("\(__FUNCTION__)")
        self.gotCharacter=character;
    }
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        println("DetailViewController\(__FUNCTION__) YES YES YES  description=\(segue.description) identifier=\(segue.identifier) sender: \(sender)")
        
    }

}
