//
//  ViewController.swift
//  DatabaseTest
//
//  Created by Tanmay Bakshi on 2014-09-02.
//  Copyright (c) 2014 TBSS. All rights reserved.
//

import UIKit

//str = TANMAY
//str[0...2]

extension String {
    
    subscript(value: Int) -> String {
        get {
            var j = 0
            for i in self.characters {
                if j == (value) {
                    return "\(i)"
                }
                j++
            }
            return ""
        }
        set(toSet) {
            var array: [String] = []
            var finalString: String = ""
            for i in self.characters {
                array.append("\(i)")
            }
            array[value] = toSet
            for i in array {
                finalString += i
            }
            self = finalString
        }
    }
    subscript(range: Range<Int>) -> String {
        get {
            var finalString = ""
            for (i, j) in self.characters.enumerate() {
                for k in range {
                    if i == k {
                        finalString.append(j)
                    }
                }
            }
            return finalString
        }
    }
    
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var name: UITextField!
    @IBOutlet var item: UITextField!
    
    @IBOutlet var uploadLabel: UILabel!
    @IBOutlet var uploadBar: UIActivityIndicatorView!
    
    @IBOutlet var backButton: UIButton!
    
    var data: NSArray = []
    
    var imagePicker = UIImagePickerController()
    
    var textStorage: [String] = []
    
    var uploadToC = uploaderClass()
    
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = dataOfJson("http://www.tanmaybakshi.com/itemRegister.php")
        print(data)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func checkForBOOLUpdate() {
        if uploadToC.doneYetFunc() == true {
            self.backButton.enabled = true
            self.uploadLabel.hidden = true
            self.uploadBar.hidden = true
            self.uploadBar.stopAnimating()
            timer.invalidate()
            timer = NSTimer()
        }
    }
    
    @IBAction func reload() {
        data = dataOfJson("http://www.tanmaybakshi.com/itemRegister.php")
        if let _ = tableview {
            self.tableview.reloadData()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func dataOfJson(url: String) -> NSArray {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        do {
            return (try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSArray)
        } catch {
            return []
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: additionInfoCell = self.tableview.dequeueReusableCellWithIdentifier("customCell") as! additionInfoCell
        if indexPath.row <= data.count {
            let maindata = (data[indexPath.row] as! NSDictionary)
            
            cell.friendName!.text = maindata["friend"] as! String
            cell.friendInfo!.text = maindata["item"] as! String
            let filName = maindata["img"] as! String
            cell.image__!.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://www.tanmaybakshi.com/itemIMG/\(filName)")!)!)
        }
        return cell
    }
    
    @IBAction func takePic() {
        textStorage = []
        textStorage.append(name.text!)
        textStorage.append(item.text!)
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true) {
            do {
                var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("checkForBOOLUpdate"), userInfo: nil, repeats: true)
                self.backButton.enabled = false
                self.uploadLabel.hidden = false
                self.uploadBar.hidden = false
                self.uploadBar.startAnimating()
                let image = info[UIImagePickerControllerOriginalImage]
                let names = self.contentsFunc()
                var numberToAdd = 0
                for i in names {
                    if i[0...4] == "image" {
                        numberToAdd++
                    }
                }
                let filName = "image\(numberToAdd).png"
                var imageData = UIImagePNGRepresentation(image as! UIImage)
                try self.uploadToC.uploadImageToServer(image as! UIImage, name: filName)
                var url: NSString = "http://www.tanmaybakshi.com/itemNew.php?x=\(self.name.text!)&y=\(self.item.text!)&b=\(filName)"
                url = url.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                url = url.stringByReplacingOccurrencesOfString("/n", withString: "%0A")
                let data = NSData(contentsOfURL: NSURL(string: url as String)!)
                _ = NSString(data: data!, encoding: NSUTF8StringEncoding)
            } catch {
                print(error)
            }
        }
    }
    
    func contentsFunc() -> [String] {
        
        data = dataOfJson("http://tanmaybakshi.com/itemRegister.php")
        
        return parseNames(data)
        
    }
    
    func parseNames(allData: NSArray) -> [String] {
        var finalNames: [String] = []
        for i in allData {
            let asDICT = i as! NSDictionary
            finalNames.append(asDICT["img"] as! String)
        }
        return finalNames
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

