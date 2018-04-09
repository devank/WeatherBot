//
//  MessageModel.swift
//  WeatherBot
//
//  Created by Devan on 09/04/18.
//  Copyright © 2018 Devan K. All rights reserved.
//

import Foundation

enum User {
    case sender
    case receiver
}

class MessageModel {
    
    var user: User?
    var message: String?
}
