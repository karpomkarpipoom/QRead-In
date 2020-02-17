//
//  Constants.swift
//  QRead
//
//  Created by Bala-MAC on 3/2/17.
//  Copyright © 2017 Erabala. All rights reserved.
//

import UIKit

class Constants: NSObject {
    
    class func CalculationFunction () -> String{
        
        return "HI How Are you"
    }
    
    class func hoursBetweenDates(date1: Date, date2: Date) -> Int {
        
        let secondsBetween = abs(Int(date1.timeIntervalSince(date2)))
        let secondsInHour = 3600
        
        return secondsBetween / secondsInHour
    }
    
}

struct Registration {
    
    let name: String?
    let age: Int?
    
    init(name: String, age: Int) {
        
        self.name = name
        self.age = age
        
    }
}
