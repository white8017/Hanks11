//
//  Page2ViewController.swift
//  線上資料庫
//
//  Created by 韓家豪 on 2016/3/2.
//  Copyright © 2016年 韓家豪. All rights reserved.
//

import UIKit

class Page2ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    


    @IBOutlet weak var SegControl: UISegmentedControl!
    @IBOutlet weak var MyTableView: UITableView!
    
    var dataArray = [AnyObject]() // 作者名稱資料
    var newAuthor = ""
    var newI = 0
    var DeleteS:String!
    var Name = ""
    var authorORbookName:String!
    
    
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let authorLbl = cell.viewWithTag(101) as! UILabel
        let newStageLbl = cell.viewWithTag(102) as! UILabel

        switch authorORbookName{
            case "author":
                authorLbl.text = dataArray[indexPath.row]["author"] as? String
                newStageLbl.backgroundColor = UIColor(red: 0.796, green: 0.996, blue: 0.772, alpha: 1.0)
                newStageLbl.text = ""
            break
            case "bookName":

                authorLbl.text = dataArray[indexPath.row]["bookName"] as? String
                var DDD:String!
                DDD = dataArray[indexPath.row]["newStage"] as? String
                newStageLbl.text = "   第 \(DDD) 話"
                newStageLbl.backgroundColor = UIColor(red: 0.964, green: 0.145, blue: 0.321, alpha: 1.0)
            break
        default:
            print("cellForRow XX")
            
        }
        
        return cell

        

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch authorORbookName{
        case "author":
        newI = indexPath.row
        self.performSegueWithIdentifier("favorites", sender: nil)
        
        print(dataArray[indexPath.row]["author"] as! String)
            break
        case "bookName":
            
            break
        default:
            print("didSelect")
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch authorORbookName{
            case "author":
        if segue.identifier == "favorites" {
            var nextViewController = segue.destinationViewController as! favoritesBookNameVC
            // 傳作者值
            nextViewController.author = dataArray[newI]["author"] as! String
            // 傳name值
            nextViewController.name = Name
            print("~\(newI)")
            
            

            
            
            //dataArray[newI]["author"] as! String

        }
            break
            case "bookName":
                print("xx")
            break
        default:
            print("prepare xx")
        }
    }
    
    
    func loadData() {
        
        switch authorORbookName{
            // 作者名稱
            case "author":
            
            let url = NSURL(string: "http://sashihara.100hub.net/vip/download.php")
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
            
            let submitName = ""
            print("sssssss\(submitName)")
            let submitBody: String = "author=\(submitName)"
            
            request.HTTPMethod = "POST"
            request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)

            
            let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())

            let dataTask = session.downloadTaskWithRequest(request)
            dataTask.resume()
            break
            
            // 追蹤漫畫
            case "bookName":
                
                let url = NSURL(string: "http://sashihara.100hub.net/vip/favoritesNameSelect.php")
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
                
                let submitBody: String = "name=\(Name)"
                
                request.HTTPMethod = "POST"
                request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
                
                
                let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
                
                let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
                
                let dataTask = session.downloadTaskWithRequest(request)
                dataTask.resume()
                
            break
            default:
            print("loadData xx")
        }
        
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {


            DeleteS = dataArray[indexPath.row]["bookName"] as! String
            dataArray.removeAtIndex(indexPath.row)
            self.deleteData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
    }
    
    func deleteData () {
        let url = NSURL(string: "http://sashihara.100hub.net/vip/deleteFavoritesName.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)

        let submitBody: String = "name=\(Name)&bookName=\(DeleteS)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()

    }

    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        switch authorORbookName {
            
        case "author":
            do {
                let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
                
                dataArray = dataDic["author"]! as! [AnyObject]
                print("\(dataArray.count) 筆資料")
                print("\(dataArray)")

                MyTableView.reloadData()
            }catch {
                print("ERROR Author")
            }
            break
            
        case "bookName":
            do {
                let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
                
                dataArray = dataDic["favorites"]! as! [AnyObject]
                print("\(dataArray.count) 筆資料")
                print(dataArray)
                
                MyTableView.reloadData()
            }catch {
                print("ERROR bookName")
            }

            break
        default:
            print("didFinish xx")

        }
    }
    
    
    func myFavorites () {
        SegControl.setTitle("作者", forSegmentAtIndex: 0)
        SegControl.setTitle("漫畫", forSegmentAtIndex: 1)
    }
    
    
    @IBAction func SegControl(sender: UISegmentedControl) {
        let to = SegControl.titleForSegmentAtIndex(SegControl.selectedSegmentIndex)!
        print(to) // 印出來
        if to == "作者" {
            authorORbookName = "author"
            self.loadData()
            print("\(authorORbookName) 作者")
        }else if to == "漫畫"{
            authorORbookName = "bookName"
            self.loadData()
            print("\(authorORbookName) 漫畫")
        }
        
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorORbookName = "bookName"
        self.loadData()
        
        self.myFavorites()
        
        
        print(Name)
        
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
