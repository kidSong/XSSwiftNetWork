//
//  XSNetworkModel.swift
//  XSNetWork
//
//  Created by SPC_IOS_01 on 2018/8/21.
//  Copyright © 2018年 sohu. All rights reserved.
//

import UIKit
import Alamofire

enum RequestMethod :Int {
    case get
    case post
    case put
    case delete
}

@objc enum URLEncodingMethod :Int{
    //直接拼接到URL中 或者 request的httpbody
    case urlEncode
    
    case jsonEncode
    
    case propertyListEncode
}

class XSNetworkModel: NSObject {
    //只有所有成员变量都有值 才会有init()方法
    convenience init(path:String,parameters:Parameters? = nil) {
        self.init()
        self.parameters = parameters
        self.path = path
    }
    
    var path:String = ""
    
    var parameters:[String:Any]? = nil
    
    var method :RequestMethod = .get
    
    var headers:HTTPHeaders  = ["Content-Type":"application/json; charset=utf-8"]
    
    var timeOutInterval:TimeInterval = 30.0
    
    var urlEncoding :URLEncodingMethod = .jsonEncode
    
    //设置可以响应的contentType 类型 服务器返回类型不包含以下 会返回falid
    var responseValidContentType:[String] = ["text/json","text/html","application/json","text/javascript","application/javascript"]
}
