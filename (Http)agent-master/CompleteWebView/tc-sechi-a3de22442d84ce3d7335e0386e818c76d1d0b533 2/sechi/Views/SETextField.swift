//
//  SETextField.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-12.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

class SETextField: UITextField {

    init(frame: CGRect) {
        super.init(frame: frame);
        self.setupView()
    }
    
    init(coder: NSCoder!) {
        super.init(coder: coder)
        self.setupView()
    }
    
    func setupView() {
        self.borderStyle = UITextBorderStyle.None
        self.backgroundColor = UIColor.whiteColor()
        self.font = TextFieldFont
    }

}
