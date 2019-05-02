//
//  Food.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/3/29.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    Food class
 */
class Food: NSObject {
    var foodId: Int?
    var userId: Int?
    var categoryId: Int?
    var locationId: Int?
    var foodName: String?
    var start: Date?
    var expire: Date?
    var price: Double?
    init(foodId:Int?,userId:Int?,categoryId:Int?,locationId:Int?,foodName:String?,start:Date?,expire:Date?,price:Double?) {
        self.foodId = foodId
        self.userId = userId
        self.categoryId = categoryId
        self.locationId = locationId
        self.foodName = foodName
        self.start = start
        self.expire = expire
        self.price = price
    }
}
