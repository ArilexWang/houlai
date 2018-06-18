//
//  Global.swift
//  houlai
//
//  Created by Ricardo on 2018/6/16.
//  Copyright © 2018年 Ricardo. All rights reserved.
//

import Foundation

let host = "http://58.41.205.160:8000/"

//登录相关
let loginWithoutCodeUrl = host + "loginWithoutCode/"
let loginWithCodeUrl = host + "loginWithCode/"

//评论相关
let loadAllCommentsUrl = host + "loadAllComments/"
let loadTodayCommentsUrl = host + "loadCommentByDayid/"
let createCommentUrl = host + "createComment/"


func getTodayDateID() -> String{
    let userCalendar = Calendar.current
    let dateCom = userCalendar.dateComponents([.year, .month,.day,.hour], from: Date())
    let dateid = String(dateCom.year!) + String(dateCom.month!) + String(dateCom.day!)
    return dateid
}

func getCurrentDateString() -> String {
    let userCalendar = Calendar.current
    let dateCom = userCalendar.dateComponents([.year, .month,.day,.hour,.minute], from: Date())
    let dateid = String(dateCom.year!) + String(dateCom.month!) + String(dateCom.day!) + String(dateCom.hour!) + String(dateCom.minute!)
    return dateid
}


extension String{
    var removeAllSlash: String{
        return self.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
    }
}



