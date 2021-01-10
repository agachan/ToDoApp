//
//  ClassSetting.swift
//  ToDoApp
//
//  Created by AGA TOMOHIRO on 2020/12/18.
//

import UIKit
import Firebase

struct Data{
    var id: String = ""
    var title: String = ""
    var url: String = ""
    var limitTime: Timestamp
    var importance: Int = 0
    var category: String = ""
    var catID:Int = 0
    var memo: String = ""
    var registTime:Timestamp
    init (data:[String:Any]) {
        self.id = data["ID"] as! String
        self.title = data["Title"] as! String
        self.url = data["URL"] as! String
        self.limitTime = data["LimitTime"] as! Timestamp
        self.importance = data["Importance"] as! Int
        self.category = data["Category"] as! String
        self.catID = data["CatID"] as! Int
        self.memo = data["Memo"] as! String
        self.registTime = data["RegistTime"] as! Timestamp
    }
    func dataToStrAny() -> [String:Any]{
        let data = ["ID":self.id,
                    "Title":self.title,
                    "URL":self.url,
                    "LimitTime":self.limitTime,
                    "Importance":self.importance,
                    "Category":self.category,
                    "CatID":self.catID,
                    "Memo":self.memo,
                    "RegistTime":self.registTime] as [String : Any]
        return data
    }
}

struct Category{
    var id: String = ""
    var name: String = ""
    var rgb: [Int] = [Int]()
    var tag: Int = 0
    init (data:[String:Any]) {
        self.id = data["ID"] as! String
        self.name = data["NAME"] as! String
        self.rgb = data["RGB"] as! [Int]
        self.tag = data["tag"] as! Int
    }
}


