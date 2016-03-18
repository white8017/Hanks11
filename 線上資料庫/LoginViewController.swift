//
//  LoginViewController.swift
//  線上資料庫
//
//  Created by 韓家豪 on 2016/3/2.
//  Copyright © 2016年 韓家豪. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, NSURLSessionDelegate, NSURLSessionDownloadDelegate {

    @IBOutlet weak var txtPasswd: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    var dataArray = [AnyObject]()
    var i = 0;

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "in" {
            var nextViewController = segue.destinationViewController as! Page2ViewController
            nextViewController.Name = dataArray[i]["name"] as! String

        }
    }
    
    @IBAction func btnLogin(sender: AnyObject) {

        for i = 0 ; i <= dataArray.count-1 ; i++ {
            var OrNamePhone:String!
            var OrNamePasswd:String!
            OrNamePhone = dataArray[i]["phoneNumber"] as! String
            OrNamePasswd = dataArray[i]["password"] as! String
            if txtPhone.text == OrNamePhone && txtPasswd.text == OrNamePasswd {

                let alert = UIAlertController(title: nil, message:"登入成功", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                    self.performSegueWithIdentifier("in", sender: nil)
                    print("yes!")
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true){}
                break
            }
            else  {
                if i == dataArray.count-1{
                    let alert = UIAlertController(title: nil, message:"電話或密碼錯誤", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                        })
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true){}
                }
                    print("--------------\(i)")
                    print(dataArray[i]["phoneNumber"]as!String)
                    print(dataArray[i]["password"]as!String)
                    print("--------------")
                
            }
        }
//        print(dataArray[i-1]["name"] as! String)
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
            print(dataArray[dataArray.count-1]["name"] as! String)
            

        }catch {
            print("ERROR")
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadData()
        
        txtPasswd.secureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
