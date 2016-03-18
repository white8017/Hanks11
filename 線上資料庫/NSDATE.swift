//
//  NSDATE.swift
//  Project
//
//  Created by 韓家豪 on 2016/3/15.
//  Copyright © 2016年 韓家豪. All rights reserved.
//

import UIKit

class NSDATE: UIViewController, NSURLSessionDelegate {

    var now = NSDate()
    var now2 = NSDateComponents()
    
    
    func loadData() {
        var to = NSDate(timeIntervalSinceNow: (24*60*60) * 5)
        var interval1 = to.timeIntervalSinceDate(now) / (3600*24)
        
        // now 改時區
        var formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        formatter.timeZone = NSTimeZone(abbreviation: "HKT")
        let now8 = formatter.stringFromDate(now)
        let to8 = formatter.stringFromDate(to)
        print(now8)
        print(to8)
        // to 改時區
        
        
//        print(to)
        print(interval1)

//        zh_TW
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale.currentLocale()
//        dateFormatter.locale = NSLocale(localeIdentifier: "en_TW")
//    
//        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
//        var convertedDate = dateFormatter.stringFromDate(now)
//        print(convertedDate)
//        print(now)
        
        let url = NSURL(string: "http://sashihara.100hub.net/vip/historyUpload.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        let submitBody:String = "rentDate=\(now8)&returnDate=\(to8)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
        
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        print("ok")
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
