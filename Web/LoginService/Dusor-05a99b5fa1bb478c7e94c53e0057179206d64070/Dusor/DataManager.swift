//
//  DataManager.swift
//  Dusor
//
//  Created by Çağdaş Salur on 06/06/14.
//  Copyright (c) 2014 Burak Çavuşoğlu. All rights reserved.
//

import Foundation
import UIKit

var dataMgr: DataManager = DataManager()

struct ders{
    var isim: String = ""
    var dKod: String = ""
    var not: String = ""
    var kredi: String = ""
    var AKTS: String = ""
    var hoca: String = ""
    var basari: String = ""
    var büt: String =  ""
    var grup: String = ""
    var yıl: String = ""
    var aDönem: String = ""
    var dönem: String = ""
    var hSaat: String = ""
    var dSaat: String = ""
    var tSaat: String = ""
    var oran: String = ""
}

class DataManager: NSObject {
    var dersler = ders[]()
    
    func dersEkle(isim:String, dKod:String, not:String, kredi:String,
        AKTS:String, hoca:String, basari:String, büt:String,
        grup:String, yıl:String, aDönem:String, dönem:String,
        hSaat:String, dSaat:String, tSaat:String, oran:String){
            
        dersler.append(ders(isim: isim, dKod: dKod, not: not,
            kredi: kredi, AKTS: AKTS, hoca: hoca, basari: basari,
            büt: büt, grup: grup, yıl: yıl, aDönem: aDönem, dönem: dönem,
            hSaat: hSaat, dSaat: dSaat, tSaat: tSaat, oran: oran))
    }
    
    func reset(){
        dersler = ders[]()
    }
}




