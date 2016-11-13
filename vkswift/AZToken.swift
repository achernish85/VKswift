//
//  AZToken.swift
//  vkswift
//
//  Created by Admin on 13.11.16.
//  Copyright © 2016 mcat345. All rights reserved.
//

import Foundation

class AZToken {
    
    private var _token: String
    private var _userID: String
    
    var token: String {
        return _token
    }
    
    var userID: String {
        return _userID
    }
    
    init(tokenString: String) {
        self._token = tokenString
        self._userID = tokenString
    }
}
