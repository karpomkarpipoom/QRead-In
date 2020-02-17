//
//  RealmObject.swift
//  QRead
//
//  Created by EraBala on 28/05/18.
//  Copyright © 2018 Erabala. All rights reserved.
//
import RealmSwift

class scanObject: Object {
    
    @objc dynamic var ScannedValue  = ""    //  String Value
    @objc dynamic var Title         = ""    //  String Title
    
    @objc dynamic var WebURL        = ""    //  URL
    
    @objc dynamic var timeDate      = ""    //  Date and Time
    @objc dynamic var Description   = ""    //  songdescription
    
    @objc dynamic var ScanId        = ""    //  ID
    @objc dynamic var type          = ""    // type of text
    
    @objc dynamic var isFavourite : Bool  = false
    
}

class createObject: Object {
    
    @objc dynamic var createImage   : String = ""   //  String Value
    @objc dynamic var Title         : String = ""   //  String Title
    @objc dynamic var CreateId      : String = ""   // String ID
    
    @objc dynamic var isFavourite   : Bool   = false
    
}
