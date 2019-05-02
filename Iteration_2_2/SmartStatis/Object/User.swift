//
//  User.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/3/29.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    User object class
 */
class User: NSObject {
    var userId: Int?
    var userFirstName: String?
    var userLastName: String?
    var userEmail: String?
    var userPassword: String?
    init(id:Int?,firstName: String?, lastName: String?,email: String?,password: String?) {
        self.userId = id
        self.userFirstName = firstName
        self.userLastName = lastName
        self.userEmail = email
        self.userPassword = password
    }
}
