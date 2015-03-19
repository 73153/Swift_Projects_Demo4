//
//  SETextFieldTableViewCell.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

class SETextFieldTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet var fieldNameLabel: UILabel
    @IBOutlet var valueTextView: SETextView
    
    /**
     *  Values needed to automate the process of saving (rewriting) input to the object.
     */
    var label: String? {
        didSet {
            self.fieldNameLabel.text = label
        }
    }
    
    var value: String? {
        didSet {
            self.valueTextView.text = value
            self.originalValue = value
            self.height = self.cellHeightForText(value)
        }
    }
    
    var key: String?
    
    var originalValue: String?
    
    /**
     *  Height that should be returned for displaying cell.
     */
    var height: Float = 63.0
    
    /**
     *  Method informs the caller if current value changed in comparsion to the original value.
     *
     *  @return BOOL indicating if was value changed
     */
    var changesWereMade: Bool {
        get {
            if let oriValue = self.originalValue? {
                if self.valueTextView.text == oriValue {
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        }
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.valueTextView.delegate = self
    }
    
    override func awakeFromNib() {
        self.valueTextView.delegate = self
    }
    
    /**
     *  Hide keyboard on return when text view is a first responder
     *
     *  @param textView
     *  @param range
     *  @param text
     *
     *  @return BOOL should change the content of the text view
     */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /**
     *  Returns height of the cell needed to properly display the cell with whole content visible.
     *
     *  @param text text for which the height should be returned
     *
     *  @return height needed to properly display the cell
     */
    func cellHeightForText(text: String?) -> Float {
        if let textStr = text? {
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .ByWordWrapping
            
            var singleLineRect = "abc".bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(self.valueTextView.frame.size.width - self.valueTextView.font.pointSize, CGFLOAT_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.valueTextView.font], context: nil)
            
            var textRect = text?.bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(self.valueTextView.frame.size.width - (self.valueTextView.font.pointSize / 2), CGFLOAT_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.valueTextView.font, NSParagraphStyleAttributeName: paragraphStyle], context: nil)
            
            var height = textRect!.size.height + singleLineRect.size.height + 8.0
            var minHeight: Float = 44.0
            return height < minHeight ? minHeight : height
        } else {
            return 44.0
        }
    }
}
