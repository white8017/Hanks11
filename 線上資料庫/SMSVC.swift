//
//  SMSVC.swift
//  線上資料庫
//
//  Created by 韓家豪 on 2016/3/11.
//  Copyright © 2016年 韓家豪. All rights reserved.
//

import UIKit


class SMSVC: UIViewController {

    @IBOutlet weak var txtTest: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBAction func btnSMS(sender: AnyObject) {
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: phoneNumber.text, zone: "886", customIdentifier: nil) { (error : NSError!) -> Void in
            
            if (error == nil)
            {
                print("成功,請等待簡訊～")
            }
            else
            {
                // 错误码可以参考‘SMS_SDK.framework / SMSSDKResultHanderDef.h’
                print("失敗", error)
            }

        }
    }
    
    @IBAction func btnTest(sender: AnyObject) {
        
        SMSSDK.commitVerificationCode(txtTest.text, phoneNumber: phoneNumber.text, zone: "886") { (error : NSError!) -> Void in
            if(error == nil){
                print("驗證成功")
            }else{
                print("驗證失敗", error)
            }
        }

    }
    @IBOutlet weak var btnSMS: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
