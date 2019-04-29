//
//  Food.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/3/29.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

class Food: NSObject {
    var foodId: Int?
    var userId: Int?
    var categoryId: Int?
    var locationId: Int?
    var foodName: String?
    var start: Date?
    var expire: Date?
    var price: Double?
    var quantity: String?
    var completion: Int?
    var keyword: String?
    init(foodId:Int?,userId:Int?,categoryId:Int?,locationId:Int?,foodName:String?,start:Date?,expire:Date?,price:Double?,quantity:String?,completion:Int?,keyword:String?) {
        self.foodId = foodId
        self.userId = userId
        self.categoryId = categoryId
        self.locationId = locationId
        self.foodName = foodName
        self.start = start
        self.expire = expire
        self.price = price
        self.quantity = quantity
        self.completion = completion
        self.keyword = keyword
    }
}
