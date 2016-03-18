//
//  imgUploadPhp.swift
//  Project
//
//  Created by 韓家豪 on 2016/3/16.
//  Copyright © 2016年 韓家豪. All rights reserved.
//

import UIKit

class imgUploadPhp: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var myImgView: UIImageView!
    @IBOutlet weak var actIV: UIActivityIndicatorView!
    
    var textField:UITextField!
    var textStr:String!
    func configurationTextField(textField: UITextField!)
    {
        print("configurat hire the TextField")
        
        if let tField = textField {
            
            self.textField = textField!        //Save reference to the UITextField
            self.textField.text = ""
            self.textField.placeholder = "輸入圖片名稱，沒輸入為預設"
        }
    }
    func handleCancel(alertView: UIAlertAction!)
    {
        print("User click Cancel button")
        print(self.textField.text)
    }
    
    @IBAction func btnOpenImg(sender: AnyObject) {
        
        
        let alert = UIAlertController(title: "上傳", message:"", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        let action = UIAlertAction(title: "⇪", style: .Default, handler: { (alert:UIAlertAction) -> Void in

            if self.textField.text == "" {
                self.textField.text = "預設"
                self.pickerImg()
            }else{
                self.pickerImg()
            }
            print(self.textField.text!)
        })
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
    }
    
    func pickerImg () {
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnUploadImg(sender: AnyObject) {
        myImageUploadRequest()
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        let tempImg = myImgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData!.writeToFile(path, atomically: true)
        
        return result
        
    }
    //
    func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        return documentsFolderPath
    }
    //
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: (path)")
        }
        print("\(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func myImageUploadRequest()
    {
        
        let myUrl = NSURL(string: "http://sashihara.100hub.net/vip/img/imgUpload.php");
        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let param = [
            "firstName"  : "Sergey",
            "lastName"   : "Kargopolov",
            "userId"    : "9"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // 圖片資料
        let imageData = UIImageJPEGRepresentation(resizeImage(myImgView.image!, newWidth: 300, newHeight: 400), 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        
        actIV.startAnimating();
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                self.actIV.stopAnimating()
//                self.myImgView.image = nil;
            });
            
            /*
            if let parseJSON = json {
            var firstNameValue = parseJSON["firstName"] as? String
            println("firstNameValue: \(firstNameValue)")
            }
            */
            
        }
        
        task.resume()
        
    }
    
    
    
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        var body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        textStr = "a"
        
        let filename = "\(textStr)\(textField.text!).jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

//改變圖片大小
func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
    image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}








