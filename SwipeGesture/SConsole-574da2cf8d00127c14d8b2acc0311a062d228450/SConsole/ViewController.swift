//
//  ViewController.swift
//  SConsole
//
//  Created by Noah on 6/14/14.
//  Copyright (c) 2014 Noah Saso. All rights reserved.
//

import UIKit
import QuartzCore

let theFrame = UIScreen.mainScreen().bounds

var textBox = UnderscoreTextView(frame: CGRectMake(15, 25, theFrame.size.width - 30, theFrame.size.height - 40))

var oldTxt = NSString(), name = NSString(string: "SConsole")
var history = NSMutableArray(), cmds = NSMutableArray(array: ["barrelroll", "clear", "quit", "exit", "help", "?", "info", "version", "fontsize"])
var version = 1.0

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        addStuff()
    }

    func addStuff() {
        
        NSLog("[\(name)] Adding stuff...")
        
        let greenTextColor = darkerColor(darkerColor(UIColor.greenColor()))
        let grayColor = UIColor(white: 0.0155, alpha: 1.0)
        
        var bgView = UIView(frame: theFrame)
        bgView.backgroundColor = UIColor.whiteColor()
        self.view = bgView
        
        var newView = UIView(frame: theFrame)
        newView.backgroundColor = UIColor.blackColor()
        bgView.addSubview(newView)
        
        var textBoxHolderView = UIView(frame: theFrame)
        textBoxHolderView.backgroundColor = grayColor
        
        textBox.backgroundColor = UIColor.clearColor()
        textBox.delegate = self
        textBox.scrollEnabled = false
        
        textBox.text = "> "
        textBox.font = UIFont(name: "Helvetica", size: 14.5)
        
        textBox.textColor = greenTextColor
        textBox.tintColor = greenTextColor
        
        textBox.returnKeyType = UIReturnKeyType.Send
        
        textBox.autocapitalizationType = UITextAutocapitalizationType.None
        textBox.autocorrectionType = UITextAutocorrectionType.No
        
        var swipeDownGesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipeDownGesture"))
        swipeDownGesture.direction = UISwipeGestureRecognizerDirection.Down
        
        var swipeUpGesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipeUpGesture"))
        swipeUpGesture.direction = UISwipeGestureRecognizerDirection.Up
        
        textBox.addGestureRecognizer(swipeDownGesture)
        textBox.addGestureRecognizer(swipeUpGesture)
        
        textBoxHolderView.addSubview(textBox)
        newView.addSubview(textBoxHolderView)
        
        textBox.becomeFirstResponder()
        
        NSLog("[\(name)] Done adding stuff!")
        
    }
    
    func textRangeFromRange(range: NSRange) -> UITextRange {
        var beginning = textBox.beginningOfDocument
        var start = textBox.positionFromPosition(beginning, offset:range.location)
        var end = textBox.positionFromPosition(start, offset:range.length)
        var textRange = textBox.textRangeFromPosition(start, toPosition:end)
        return textRange
    }
    
    var curLn = 0
    
    func handleSwipeUpGesture() {
        if history.count == 0 { return }
        if curLn < 0 { curLn = history.count - 1 }
        
        var currentLine = textBox.text.componentsSeparatedByString("\n").bridgeToObjectiveC().objectAtIndex(0).substringFromIndex(2) as NSString
        
        var nextLine = history.objectAtIndex(curLn--) as NSString
        let theRange = textRangeFromRange(NSMakeRange(2, currentLine.length))
        
        textBox.replaceRange(theRange, withText: nextLine)
    }
    func handleSwipeDownGesture() {
        textBox.resignFirstResponder()
    }
    
    func setCursorToBeginning() {
        var currentLine = textBox.text.componentsSeparatedByString("\n").bridgeToObjectiveC().objectAtIndex(0) as NSString
        var len = currentLine.length
        textBox.selectedRange = NSMakeRange(len, 0)
        NSLog("[\(name)] Set cursor to beginning!")
    }
    
    func sendCursorToBeginning() {
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("setCursorToBeginning"), userInfo: nil, repeats: false)
    }
    
    func darkerColor(c: UIColor) -> UIColor {
        var h: CGFloat = 0.0, s: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        if c.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            return UIColor(hue: h, saturation: s, brightness: b * 0.85, alpha: a)
        }
        return UIColor.blackColor();
    }
    
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        sendCursorToBeginning()
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        
        let firstLine = textView.text.componentsSeparatedByString("\n").bridgeToObjectiveC().objectAtIndex(0) as NSString
        let lengthOfFirst = firstLine.length
        
        let length = textView.selectedRange.length
        let location = textView.selectedRange.location
        
        if length > 0 {
            if length + location > lengthOfFirst {
                textView.selectedRange = NSMakeRange(2, lengthOfFirst - 2)
            }
        }
        
        if location > lengthOfFirst {
            setCursorToBeginning()
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange: NSRange, replacementText theNewText: NSString) -> Bool {
        
        oldTxt = textBox.text.bridgeToObjectiveC()
        
        let carPos: NSRange = shouldChangeTextInRange
        
        if carPos.location <= 1 && theNewText.isEqualToString("") {
            return false
        }
        
        if theNewText.isEqualToString("\n") {
            
            var cmd = textView.text
            let firstLine = cmd.componentsSeparatedByString("\n").bridgeToObjectiveC().objectAtIndex(0) as NSString
            cmd = firstLine.componentsSeparatedByString("> ").bridgeToObjectiveC().objectAtIndex(1) as NSString
            cmd = cmd.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            if cmd.isEmpty { return false }
            
            processCommand(cmd)
            
            newLineInput()
            
            return false
            
        }
        
        return true
        
    }
    
    func textViewDidChange(textView: UITextView) {
        if !(oldTxt.length - 1 == textBox.text.bridgeToObjectiveC().length) {
            predict(textView)
        }
    }
    
    func predict(textView: UITextView) {
        
        NSLog("[\(name)] Predicting...")
        
        var cmd: NSString = textView.text
        cmd = cmd.componentsSeparatedByString("\n").bridgeToObjectiveC().objectAtIndex(0) as NSString
        cmd = cmd.componentsSeparatedByString("> ").bridgeToObjectiveC().objectAtIndex(1) as NSString
        cmd = cmd.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).bridgeToObjectiveC()
        
        let len = cmd.length
        if len == 0 { return }
        
        let txtRng = NSMakeRange(2, len)
        
        var wordsFound: NSMutableArray = NSMutableArray()
        
        for i in 0..cmds.count {
            
            var str = cmds[i] as NSString
            
            if str.length < len { continue }
            
            var someLetters = str.substringToIndex(len).bridgeToObjectiveC()
            
            if cmd.isEqualToString(someLetters) {
                //var predictedWord = str.substringFromIndex(len) as NSString
                wordsFound.addObject(str)
                
                NSLog("[\(name)] Detected: \(str)")
            }
            
        }
        
        if wordsFound.count <= 0 { return }
        
        if wordsFound.count == 1 {
            //var newText = NSMutableString(string: textView.text)
            //newText.insertString(wordsFound[0] as NSString, atIndex: txtRng.location + 1)
            //NSLog("NEW: %@", newText)
            
            var newText = textView.text.bridgeToObjectiveC().stringByReplacingCharactersInRange(txtRng, withString: wordsFound[0] as NSString)
            textView.text = newText
            
            /*
            let greenTextColor = darkerColor(darkerColor(UIColor.greenColor()))
            var attStr: NSMutableAttributedString = NSMutableAttributedString(string: newText)
            
            attStr.addAttribute(NSForegroundColorAttributeName, value: greenTextColor, range: NSMakeRange(0, newText.length))
            
            NSLog(wordsFound[0] as NSString)
            var range = newText.rangeOfString(wordsFound[0] as NSString)
            attStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: range)
            
            textView.attributedText = NSAttributedString(attributedString: attStr)
            */
        }
        
    }
    
    func processCommand(cmd: NSString) {
        
        NSLog("[\(name)] CMD: \(cmd)")
        
        history.addObject(cmd)
        
        curLn = history.count - 1
        
        var args = NSMutableArray()
        args[0] = cmd
        
        if cmd.rangeOfString(" ").location != NSNotFound {
            var theArgs = cmd.componentsSeparatedByString(" ")
            for var i = 0; i < theArgs.count; i++ {
                args[i] = theArgs[i]
            }
        }
        
        switch(args[0] as NSString) {
            
        case "barrelroll":
            textBox.resignFirstResponder()
            
            var animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.toValue = NSNumber(double: M_PI * 2)
            animation.cumulative = true
            animation.duration = 1.5
            animation.delegate = self
            
            if args.count > 1 {
                if args[1].floatValue == 0 {
                    break
                }
                animation.repeatCount = args[1].floatValue
            }
            
            var theView: UIView = self.view.subviews[0] as UIView
            theView.layer.addAnimation(animation, forKey: cmd)
            
            addLine("Do a barrel roll!")
            
        case "clear":
            textBox.text = ""
            
        case "quit", "exit":
            exit(0)
            
        case "fontsize":
            if args.count == 1 {
                addLine("Syntax: fontsize <number>")
                break
            }
            var newFont = args[1] as NSString
            
            var notDigits = NSMutableCharacterSet(charactersInString: ".")
            notDigits.formUnionWithCharacterSet(NSCharacterSet.decimalDigitCharacterSet())
            notDigits = notDigits.invertedSet.mutableCopy() as NSMutableCharacterSet
            
            if args[1].rangeOfCharacterFromSet(notDigits).location != NSNotFound {
                addLine("Make sure you entered a valid number")
                break
            }
            var fontFloat = args[1].floatValue
            if fontFloat < 10.0 { fontFloat = 10.0 }
            textBox.font = UIFont(name: "Helvetica", size: fontFloat)
            NSLog("[\(name)] New font size: \(fontFloat)")
            addLine("Set font size to: \(fontFloat)")
            
        case "help", "?":
            addLine("")
            addLine("---------------")
            addLine("barrelroll [count] -- Do a barrel roll")
            addLine("clear -- Clear history below")
            addLine("quit , exit -- Close this app")
            addLine("help , ? -- Display this menu")
            addLine("fontsize <number> -- Change font size")
            addLine("info , version -- Display info (version, creator, etc.)")
            addLine("")
            addLine("< > = required, [ ] = optional")
            addLine("---------------")
            addLine("Help Menu")
            addLine("")
            
        case "info", "version":
            addLine("")
            addLine("------")
            addLine("Version: v\(version)")
            addLine("Creator: Sassoty")
            addLine("------")
            addLine("Info")
            addLine("")
            
        default:
            addLine("Unknown command")
            
        }
        
    }
    
    func newLineInput() {
        addLine("> ")
    }
    
    func addLine(text: NSString) {
        NSLog("[\(name)] Added: \(text)")
        var str = "\(text)\n\(textBox.attributedText.string.bridgeToObjectiveC())"
        //textBox.attributedText = NSAttributedString(string: str)
        textBox.text = str
        sendCursorToBeginning()
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("startEditingTextBox"), userInfo: nil, repeats: false)
    }
    
    func startEditingTextBox() {
        textBox.becomeFirstResponder()
    }
    
}

class UnderscoreTextView: UITextView {
    
    override func caretRectForPosition(position: UITextPosition) -> CGRect {
        var myRect = super.caretRectForPosition(position)
        myRect.origin.y = myRect.size.height + 3
        myRect.origin.x += 2
        myRect.size.width = 11
        myRect.size.height = 1.5
        return myRect
    }

}

