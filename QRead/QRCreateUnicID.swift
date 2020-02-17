//
//  QRCreateUnicID.swift
//  QRead
//
//  Created by OmniproEdge on 02/11/18.
//  Copyright © 2018 Erabala. All rights reserved.
//

import Foundation

class unique {
    
    func createUniceID() -> String{
        
        let unicNum = UserDefaults.standard.integer(forKey: "UUIDUnic")
                
        let value = unicNum + 1
        
        UserDefaults.standard.set(value, forKey: "UUIDUnic")
        
        let uuid = NSUUID().uuidString
        
        let stringId = uuid + "\(unicNum)"
        
        return stringId
    }
    
}
