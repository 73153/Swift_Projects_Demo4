//
//  ViewController.swift
//  Dusor
//
//  Created by Burak Çavuşoğlu on 05/06/14.
//  Copyright (c) 2014 Burak Çavuşoğlu. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, NSURLConnectionDelegate {
    @IBOutlet var tvPw : UITextField
    @IBOutlet var tvNo : UITextField
    @IBOutlet var btGiriş : UIButton
    
    override func viewDidLoad(){
        super.viewDidLoad()
        btGiriş.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func buttonAction(sender: UIButton!){
        println(tvNo.text + ":" + tvPw.text)
        
        let urlPath: String = "http://107.170.167.72:8080/?usr=\(tvNo.text)&pw=\(tvPw.text)&json=true"
        var rawJSON = getJSON(urlPath)
        
        if (rawJSON == nil){
            alert("Server'a erişilemiyor", message: "İnternet Bağlantınızı kontrol edip daha sonra tekrar deneyin.", button: "Tamam")
            return
        }
        
        var parsedJSON = parseJSON(rawJSON)
        var hata = parsedJSON["hata"] as String
        
        println(hata)
        
        if hata == "-"
        {
            dataMgr.reset()
            saveJSON(parsedJSON)
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("menu") as UIViewController;
            self.presentViewController(vc, animated: true, completion: nil);
        }
        else
        {
            alert("Hata", message: "Kullanıcı adı veya şifre hatalı.", button: "Tamam")
            return
        }
    }
    
    func alert(title: String, message: String, button: String){
        //let alert = UIAlertController(title: "Hata", message: "Kulanıcı adı veya şifre hatalı.", preferredStyle: UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.Default, handler: nil))
        //self.presentViewController(alert, animated: true, completion: nil)
        var alertView = UIAlertView();
        alertView.addButtonWithTitle(button);
        alertView.title = title;
        alertView.message = message;
        alertView.show();
    }
    
    func saveJSON(json: NSDictionary){
        
        var dersler:String[][] = json["dersler"] as String[][]
        for ders:String[] in dersler
        {
            var tp = String[]()

            for line : String in ders
            {
                tp.append(line)
            }
            
            println(tp)
            println(tp.count)
            if (tp.count < 17)
            {
                dataMgr.dersEkle(tp[4], dKod: tp[2], not: tp[8],
                    kredi: tp[5], AKTS: tp[7], hoca: tp[8], basari: tp[9],
                    büt: tp[10], grup: tp[11], yıl: tp[1], aDönem: tp[1], dönem: tp[2],
                    hSaat: "", dSaat: "", tSaat: "", oran: "")
            }
            else
            {
                dataMgr.dersEkle(tp[4], dKod: tp[2], not: tp[8],
                    kredi: tp[5], AKTS: tp[7], hoca: tp[8], basari: tp[9],
                    büt: tp[10], grup: tp[11], yıl: tp[1], aDönem: tp[1], dönem: tp[2],
                    hSaat: tp[13], dSaat:tp[14], tSaat: tp[15], oran: tp[16])
            }
        }
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest))
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        return boardsDictionary
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

