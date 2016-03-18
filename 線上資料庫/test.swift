//
//  test.swift
//  Project
//
//  Created by 韓家豪 on 2016/3/16.
//  Copyright © 2016年 韓家豪. All rights reserved.
//

import UIKit

class test: UIViewController,UITableViewDelegate,UITableViewDataSource{

    let dataArray = ["123","444"]
    
    
    
}

extension test {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let NameLbl = cell.viewWithTag(201) as! UILabel
        
//        NameLbl.text = dataArray[indexPath.row]
        
        return cell
        
    }
}
