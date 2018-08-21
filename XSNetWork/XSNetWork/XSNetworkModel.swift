//
//  XSNetworkModel.swift
//  XSNetWork
//
//  Created by SPC_IOS_01 on 2018/8/21.
//  Copyright © 2018年 sohu. All rights reserved.
//

import UIKit
import Alamofire

let XSRequest_TimeOut_Seconds = 30.0


enum RequestMethod :Int {
    case get
    case post
    case put
    case delete
}

class XSNetworkModel: NSObject {
    var path:String = ""
    
    var parameters:[String:Any]? = nil
    
    var method :RequestMethod = .post
    
    var headers:HTTPHeaders  = ["Content-Type":"application/json; charset=utf-8"]
    
    var timeOutInterval:TimeInterval = XSRequest_TimeOut_Seconds
    
    
}
