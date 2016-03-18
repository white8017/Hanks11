//
//  favoritesBookNameVC.swift
//  線上資料庫
//
//  Created by 韓家豪 on 2016/3/7.
//  Copyright © 2016年 韓家豪. All rights reserved.
//

import UIKit

class favoritesBookNameVC: UIViewController,UITableViewDelegate,UITableViewDataSource, NSURLSessionDelegate, NSURLSessionDownloadDelegate {

    var dataBookName = [AnyObject]() // 漫畫名稱資料
    var author = ""
    var addBookName:String!
    var addBookStage:String!
    var addString:String!
    var name = ""

//    let goNext = UIButton()

    
    @IBOutlet weak var MyTableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBookName.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let bookNameLbl = cell.viewWithTag(201) as! UILabel
        let newStageLbl = cell.viewWithTag(202) as! UILabel

            bookNameLbl.text = dataBookName[indexPath.row]["bookName"] as? String
            newStageLbl.text = dataBookName[indexPath.row]["newStage"] as? String

        return cell


    }
    
    func loadData() {
        addString = "select"
        let url = NSURL(string: "http://sashihara.100hub.net/vip/getFavoritesBookName.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)

        let submitName = author
        let submitBody: String = "author=\(submitName)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
//        addString = "sss"
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backPage2" {
            var nextViewController = segue.destinationViewController as! Page2ViewController
            nextViewController.Name = name
        }
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
            if editingStyle == UITableViewCellEditingStyle.Delete {
                dataBookName.removeAtIndex(indexPath.row)

                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        
    }
    

    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
     
        if addString == "select" {
        do {
            let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
            
            
            dataBookName = dataDic["bookDetails"]! as! [AnyObject]
            
            print("\(dataBookName.count) 筆資料")
            print(dataBookName)
            
            MyTableView.reloadData()
            addString = "先換掉"
        }catch {
            print("ERROR xx")
        }
        }else{
            print("xx")
        }
    }

    // 查看點選到哪一個Cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        addBookName = dataBookName[indexPath.row]["bookName"] as! String
        addBookStage = dataBookName[indexPath.row]["newStage"] as! String
        
        self.favorites()
    }
    
    
    // 點選漫畫新增追蹤
    func favorites() {

        let url = NSURL(string: "http://sashihara.100hub.net/vip/addFavorites.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        let submitBody:String = "bookName=\(addBookName)&newStage=\(addBookStage)&name=\(name)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        goNext.frame = CGRectMake(20, 200, 156, 200)
//        goNext.setTitle("返回", forState: UIControlState.Normal)
//        goNext.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
//        goNext.addTarget(self, action: "goNext:", forControlEvents:  UIControlEvents.TouchUpInside)
//        self.view.addSubview(goNext)
        
        
        self.loadData()
        



        // Do any additional setup after loading the view.
    }
    
//    func goNext(sender: UIButton!) {
//        self.performSegueWithIdentifier("backPage2", sender: nil)
//        addString = "oh~~"
//    }

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
