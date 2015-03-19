//
//  SETextView.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

class SETextView: UITextView {

    init(frame: CGRect, textContainer: NSTextContainer!) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.whiteColor()
        self.font = TextFieldFont
    }
}
