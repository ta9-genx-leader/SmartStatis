//
//  HttpUrl.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/5/19.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

public class HttpUrl {
    
    required init() {
        
    }
    // Youtube API key
    let youtubeApiKey = "AIzaSyDSqPMGrUCyPyrZWSkCSABN6cgsU9EaH2I"
    
    // Imgur API client ID
    let imgurClientId = "Client-ID 546c25a59c58ad7"
    
    // User (AWS API Gateway)
    let getAllUserSQL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/getalluser"
    
    let addUserSQL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/adduser"
    
    let getUserByEmailAndPassword = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/getuserbyemailandpassword"
    
    // Receipt (AWS API Gateway)
    let updateReceipt = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/receipt/uploadreceipt"
    
    // Category (AWS API Gateway)
    let getAllCategory = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/getallcategory"
    
    // Report (AWS API Gateway)
    let getReportData = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/getreportdata"
    
    // Food (AWS API Gateway)
    let getFoodById = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/getfoodbyuid"
    
    let addFood = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/addfood"
    
    let deleteFood = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/deletefoodbyid"
    
    let updateFoodCompletion = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/updatefoodcompletion"
    
    let updateFoodById = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/updatefoodbyid"
    
    let updateFoodPrice = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/updatefoodprice"
    
    let addFoodWithQuantity = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/addfoodwithquantity"
    
    let getShoppingFoodByUid = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/getshoppingfoodbyuid"
    
    let getNextFoodId = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/getnexyfoodid"
    
    let addFoodWithIdAndKeyword = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/addfoodwithidandkeyword"
    
    let updateFoodLoactionById = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/updatefoodlocationbyid"
    
    let updateQuantityById = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/updatequantitybyid"
    
    // Get Youtube API url
    func getYoutubeUrl(videoType:String,apiKey:String) -> String{
        return "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(videoType)&type=video&videoSyndicated=true&chart=mostPopular&maxResults=10&safeSearch=strict&order=relevance&order=viewCount&type=video&relevanceLanguage=en&regionCode=AU&key=\(apiKey)"
    }
}
