//
//  ViewController.swift
//  線上資料庫
//
//  Created by 韓家豪 on 2016/2/24.
//  Copyright © 2016年 韓家豪. All rights reserved.
//

import UIKit

let Screen = UIScreen.mainScreen().bounds
class ViewController: UIViewController,NSURLSessionDelegate, NSURLSessionDownloadDelegate{


    @IBOutlet weak var txtAdess: UITextField!
    @IBOutlet weak var txtPasswdCheck: UITextField!
    @IBOutlet weak var txtPasswd: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var verificationCode: UITextField!
    @IBOutlet weak var btnGo: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    
    var check:String!
    var dataArray = [AnyObject]()
    var smsStr:String!
    var verificationCodeStr:String!
    let txtVerificationCode: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 5, y: 35,width:10, height: 40));
    
    func alertPg (txt: String) {
        let alert = UIAlertController(title: txt , message:nil , preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
        })
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
    }

    @IBAction func btnVerificationCode(sender: AnyObject) {
        SMSSDK.commitVerificationCode(txtVerificationCode.text, phoneNumber: verificationCodeStr, zone: "886") { (error : NSError!) -> Void in
            if(error == nil){
                print("驗證成功")
                let alert = UIAlertController(title: nil, message:"註冊成功", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                    self.singUp()
                    self.performSegueWithIdentifier("singup", sender: nil)
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true){}
            }else{
                print("電話驗證有誤", error)
                self.alertPg("電話驗證有誤")
            }
        }
    }
    
    func SMS () {
        smsStr = txtPhone.text
        var ns1 = smsStr as NSString
        verificationCodeStr = ns1.substringFromIndex(1)
        
        if txtPhone.text != "" {
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: verificationCodeStr as String, zone: "886", customIdentifier: nil) { (error : NSError!) -> Void in
            
            
            if (error == nil)
            {
                print("電話\(ns1.substringFromIndex(1))")
                print("成功,請等待簡訊～")
                self.alertPg("成功，請等待簡訊")
            }
            else
            {
                // 错误码可以参考‘SMS_SDK.framework / SMSSDKResultHanderDef.h’
                print("失敗", error)
                self.alertPg("電話有誤或每分鐘發短信數量超出限制")
            }
            
            }
        }else {
            alertPg("請輸入電話")
        }

    }
    
    @IBAction func btnUpdate(sender: AnyObject) {
        
        
                if self.txtName.text == "" || self.txtPasswd.text == "" || self.txtBirthday.text == "" || self.txtPhone.text == "" || self.txtAdess.text == "" {
                    self.alertPg("資料填寫未完成")
                }else if self.txtPasswd.text != self.txtPasswdCheck.text{
                    self.alertPg("密碼確認錯誤")
                }else{
                    self.check = "check"
                    for var i = 0 ; i <= self.dataArray.count-1 ; i++ {
                        if self.dataArray[i]["phoneNumber"] as! String == self.txtPhone.text {
                            self.alertPg("此電話已申請過")
                            self.check = "XX"
                        }else if i == self.dataArray.count-1 && self.check != "XX"{
                            
                            SMS()

                            
                            UIView.transitionWithView(self.view, duration: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in

//                                self.txtAdess.hidden = true;
//                                self.txtBirthday.hidden = true; 
//                                self.txtName.hidden = true
//                                self.txtPasswd.hidden = true
//                                self.txtPasswdCheck.hidden = true
//                                self.txtPhone.hidden = true
//                                self.btnGo.hidden = true
                                
                                self.txtAdess.alpha = 0.0
                                self.txtBirthday.alpha = 0.0
                                self.txtName.alpha = 0.0
                                self.txtPasswd.alpha = 0.0
                                self.txtPasswdCheck.alpha = 0.0
                                self.txtPhone.alpha = 0.0
                                self.btnGo.alpha = 0.0
                                
                                }) { (Bool) -> Void in
                                    return true
                            }

                            // 驗證碼的動畫
                            UIView.transitionWithView(self.view, duration: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in

                                self.txtVerificationCode.frame = CGRectMake(Screen.width / 2 - 150, 35, 300, 40)
                                self.txtVerificationCode.alpha = 1
                                
                                }) { (Bool) -> Void in
                                    return true
                            }
                            
                        }
                    }
        }
    }
    
    func singUp() {
        let url = NSURL(string: "http://sashihara.100hub.net/vip/UpLoad.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        let submitBody:String = "name=\(txtName.text!)&phoneNumber=\(txtPhone.text!)&birthday=\(txtBirthday.text!)&password=\(txtPasswd.text!)&adess=\(txtAdess.text!)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
        
        
    }
    
    func loadData() {
        let url = NSURL(string: "http://sashihara.100hub.net/vip/memberDownload.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()

    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        do {
            let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
            
            dataArray = dataDic["member"]! as! [AnyObject]
            print("\(dataArray.count) 筆資料")
            print("wddd\(dataArray[dataArray.count-1]["name"] as! String)")
            
        }catch {
            print("ERROR")
        }

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadData()
        
        txtPasswd.secureTextEntry = true
        txtPasswdCheck.secureTextEntry = true
        

//        let txtVerificationCode: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 150, y: 35,width:300, height: 40));
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6).CGColor //底線的顏色
        border.frame = CGRect(x: 0, y: txtVerificationCode.frame.size.height - width, width:  txtVerificationCode.frame.size.width, height: txtVerificationCode.frame.size.height)
        
        border.borderWidth = width
        txtVerificationCode.layer.addSublayer(border)
        txtVerificationCode.layer.masksToBounds = true
        txtVerificationCode.alpha = 0
        txtVerificationCode.text = ""
        txtVerificationCode.placeholder = "簡訊驗證碼"
        self.view.addSubview(txtVerificationCode)
        

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

