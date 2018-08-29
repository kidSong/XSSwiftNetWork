//
//  XSNetworkService.swift
//  XSNetWork
//
//  Created by SPC_IOS_01 on 2018/8/22.
//  Copyright © 2018年 sohu. All rights reserved.
//

import UIKit
import Alamofire

let XSRequest_TimeOut_Seconds : TimeInterval = 30.0
let XS_MAX_Connection_Per_Host = 4;

class XSNetworkService: NSObject {
    static let shareInstance = XSNetworkService();
    
    private override init() {
        super.init()
    }
    
    public lazy var defaultManager :SessionManager = {
        let defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = XSRequest_TimeOut_Seconds
        configuration.httpMaximumConnectionsPerHost = XS_MAX_Connection_Per_Host
        configuration.httpAdditionalHeaders = defaultHeaders;
        var sessionManager = createSessionManager(configuration: configuration)
        return sessionManager
        
    }()
    
    //为什么这个参数 不能指定类型 因为【：】相当于是个对象
    func createSessionManager(configuration:URLSessionConfiguration,serverTrustPolicyManager:ServerTrustPolicyManager? = customServerTrusePolicyManager(policies: [ : ])) -> SessionManager {
        let sessionMaager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: serverTrustPolicyManager)
        return sessionMaager
    }
}


class customServerTrusePolicyManager: ServerTrustPolicyManager {
    /*
       open 的作用是原来public 的作用，其他模块可以继承重载
       public 其他模块不可以继承重载 在模块内可以被继承和重载
       模块以framework区分
     */
    open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        let serverTrustPolicy = ServerTrustPolicy.pinCertificates(certificates: ServerTrustPolicy.certificates(), validateCertificateChain: false, validateHost: false)
        return serverTrustPolicy
    }
}

extension XSNetworkService{
    //取消如果不使用返回值的警告
    @discardableResult
    func sendRequest<T:Codable>(modelType:T.Type,
                                netModel:XSNetworkModel,
                                success:((T)->())? = nil,
                                faild:((Error,String)->())? = nil,
                                progressBlock:((Progress)->())? = nil
                                ) -> DataRequest? {
        return self.sns_sendRequestBase(session: defaultManager, netModel: netModel,success:{(data) in self.disposeResult(modelType:modelType, data: data,success:success,faild:faild)}, faild:faild, progressBlock:progressBlock)
    }
    
    
    private func sns_sendRequestBase(session:SessionManager,
                                     netModel:XSNetworkModel,
                                     success:((Data)->())? = nil,
                                     faild:((Error,String)->())? = nil,
                                     progressBlock:((Progress)->())? = nil
                                     ) -> DataRequest? {
        var originalRequest:URLRequest?
        do {
            originalRequest = try URLRequest(url: netModel.path, method: self.changeToHttpMethod(method: netModel.method), headers: netModel.headers)
            var encodUrlRequest = try  self.changeToParameEncode(encodeType: netModel.urlEncoding).encode(originalRequest!, with: netModel.parameters)
            encodUrlRequest.timeoutInterval = netModel.timeOutInterval
            
            return session.request(encodUrlRequest).validate(statusCode: 200..<3000).validate(contentType: netModel.responseValidContentType).responseData { (response) in
                if let value = response.value{
                    success?(value)
                }else{
                    faild?(response.error!,"服务器没返回")
                }
            }
        } catch  {
            //这个error是catch里面带过来的？？？
            faild?(error,"url编码错误")
        }
        return nil
    }
    
    func changeToHttpMethod(method:RequestMethod) -> HTTPMethod {
        var httpMethod:HTTPMethod!
        
        switch method {
        case .get:
            httpMethod = .get
        case .post:
            httpMethod = .post
        case .delete:
            httpMethod = .delete
        case .put:
            httpMethod = .put
        }
        
        return httpMethod;
    }
    
    func changeToParameEncode(encodeType:URLEncodingMethod) -> ParameterEncoding {
        var coding : ParameterEncoding!
        switch encodeType {
        case .urlEncode:
            coding = URLEncoding.default
        case .jsonEncode :
            coding = JSONEncoding.default
        case .propertyListEncode :
            coding = PropertyListEncoding.default
     
        }
        return coding
    }
    
    func disposeResult<T:Codable>(modelType:T.Type,data:Data,success:((T)->())? = nil,faild:((Error,String)->())? = nil) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do{
            let jsonModel = try decoder.decode(modelType, from: data)
            success?(jsonModel)
        }catch{
            faild?(error,"模型解析失败")
        }
    }
    
}
