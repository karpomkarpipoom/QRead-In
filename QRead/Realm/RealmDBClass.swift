//
//  RealmDBClass.swift
//  QRead
//
//  Created by OmniproEdge on 31/07/18.
//  Copyright © 2018 Erabala. All rights reserved.
//

import UIKit
import RealmSwift

let realm = try! Realm()

var scanCategories      : Results<scanObject>   = { realm.objects(scanObject.self)      }()
var createCategories    : Results<createObject> = { realm.objects(createObject.self)    }()

let RealmScanObject = realm.objects(scanObject.self)

class RealmObject : NSObject {
    
    func saveScanData( webURL : String, title : String, actualData : String, timeDate : String, description : String, scanId : String, type : String ){
        
        let scanData = scanObject()
        
        if webURL != "" {
            scanData.WebURL = webURL as String
        }
        
        if title != "" {
            scanData.Title = title as String
        }
        
        if actualData.count != 0{
            scanData.ScannedValue = actualData as String
        }
        
        if timeDate.count != 0{
            scanData.timeDate = timeDate as String
        }
        
        if description.count != 0{
            scanData.Description = description as String
        }
        
        if scanId.count != 0{
            scanData.ScanId = scanId as String
        }
        
        if type.count != 0{
            scanData.type = type as String
        }
        
        try! realm.write() {
            realm.add(scanData)
        }
        
        scanCategories = realm.objects(scanObject.self)
    }
    
    func saveGenerateData( imageData : String , title : String, CreateId : String ){
        
        let GenerateData = createObject()
        
        if imageData.count < 1 { }
        
        if imageData.count != 0 {
            GenerateData.createImage = imageData as String
        }
        
        if title != "" {
            GenerateData.Title = title as String
        }
        
        if CreateId != ""{
            GenerateData.CreateId = CreateId as String
        }
        
        try! realm.write() {
            realm.add(GenerateData)
        }
        
        createCategories = realm.objects(createObject.self)
    }
    
    // MARK:- Update the Value
    
    func UpdateScanValue(PredicedValue : String, UpdatedValue : Bool) {
        
        let workouts = realm.objects(scanObject.self).filter("ScanId = %@", PredicedValue)
        
        let realm = try! Realm()
        
        if let workout = workouts.first {
            
            try! realm.write {
                workout.isFavourite = UpdatedValue
            }
        }
    }
    
    // Delete the Value for Scan Object
    func deleteTheValue(PredicatedValue : String) {
        
        let realm = try! Realm()
        
        let repeatedItem = realm.objects(scanObject.self).filter("ScanId = %@",PredicatedValue)
        
        try! realm.write({
            
            realm.delete(repeatedItem)
            
        })
    }
    
    // Delete the Value for Gendrat Object
    func deleteTheGenrateValue(PredicatedValue : String) {
        
        let realm = try! Realm()
        
        let repeatedItem = realm.objects(createObject.self).filter("CreateId = %@",PredicatedValue)
        
        try! realm.write({
            
            realm.delete(repeatedItem)
            
        })
    }
    
    
    func FechData(){ }
}
