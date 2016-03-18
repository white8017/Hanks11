//
//  depositVC.swift
//  線上資料庫
//
//  Created by 韓家豪 on 2016/3/9.
//  Copyright © 2016年 韓家豪. All rights reserved.
//

import UIKit

class depositVC: UIViewController, NSURLSessionDelegate  {

    @IBOutlet weak var txtDeposit: UITextField!
    @IBOutlet weak var txtPhone: UITextField!

    func alertPg (txt: String) {
        let alert = UIAlertController(title: txt , message:nil , preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
        })
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
    }
    
    
    @IBAction func btnDeposit(sender: AnyObject) {
        if txtPhone.text! == ""  {
            txtPhone.placeholder = "請輸入電話！"
        }else if txtDeposit.text! == "" {
            txtDeposit.placeholder = "請輸入金額！"
        }else {
            let alert = UIAlertController(title: "儲值確認", message: "電話為\(txtPhone.text!)\n儲值金額\(txtDeposit.text!)", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                self.alertPg("儲值完畢")
                self.loadData()

                
            })
            let action2 = UIAlertAction(title: "取消", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                
            })
            alert.addAction(action)
            alert.addAction(action2)
            self.presentViewController(alert, animated: true){}
        }
    }

    func loadData() {

        let url = NSURL(string: "http://sashihara.100hub.net/vip/updateDeposit.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        let submitBody:String = "deposit=\(txtDeposit.text!)&phoneNumber=\(txtPhone.text!)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
