//
//  ViewController.swift
//  XSNetWork
//
//  Created by SPC_IOS_01 on 2018/8/21.
//  Copyright © 2018年 sohu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let model = XSNetworkModel.init(path: "https://xsongtest.com")
        XSNetworkService.shareInstance.sendRequest(modelType: XSUserModel.self, netModel: model, success: { (user) in
            print(user)
        },  faild: { (error, tips) in
            print(tips)
        }, progressBlock: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

