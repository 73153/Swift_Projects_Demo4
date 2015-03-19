//
//  NotBilgisi.swift
//  Dusor
//
//  Created by HasanRiza on 5.06.2014.
//  Copyright (c) 2014 Burak Çavuşoğlu. All rights reserved.
//

import Foundation
import UIKit

class NotBilgisi: UIViewController {
    
    @IBOutlet var svNotlar : UITextView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var st = ""
        for ders in dataMgr.dersler
        {
            st += "Ders ismi: \(ders.isim)\n"
            st += "Ders kodu: \(ders.dKod)\n"
            st += "Ders kredisi: \(ders.kredi)\n"
            st += "Ders hocası: \(ders.hoca)\n"
            st += "Devam durumu: \(ders.oran)\n"
            st += "Başarı notu: \(ders.basari)\n"
            st += "--------------\n"
        }
        svNotlar.text = st

    }
    
    //override func shouldAutorotate() -> Bool {return false}
    //override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation) -> Bool {return true}
    
    
}

