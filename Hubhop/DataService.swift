//
//  DataService.swift
//  Hubhop
//
//  Created by Xuan Yang on 9/27/15.
//  Copyright © 2015 MiraCode. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "https://hubhop.firebaseio.com")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    
}