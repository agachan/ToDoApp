//
//  Protocol.swift
//  ToDoApp
//
//  Created by AGA TOMOHIRO on 2020/12/18.
//

import UIKit

protocol CatchProtocol {
    func sortViewData(tag: Int)
    func registViewData(statusNum: Int)
}

protocol CategoryProtocol {
    func getCagegoryData(text:String,index:Int)
}

protocol CategorySettingProtocol {
    func getCagegoryData(text:String,index:Int)
}

protocol ProfileProtocol {
    func getImageName(name:String,image:UIImage)
}
