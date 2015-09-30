//
//  FeedVC.swift
//  Hubhop
//
//  Created by Xuan Yang on 9/27/15.
//  Copyright © 2015 MiraCode. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelectorImg: UIImageView!
    
    var posts = [Post]()
    static var imageCach = NSCache()
    var imagePicker: UIImagePickerController!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 358
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        // listen to whatever change made to the data
        
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: {snapshot in  //.Value: ANY DATA CHANGE
            
            self.posts = [] //clear up the data every time reload the data
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                        
                    }
                }
            }
            
            self.tableView.reloadData()
             
        })
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print("\(post.postDescription)")
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            cell.request?.cancel()
            
            var img: UIImage?
            
            if let url = post.imageUrl {
                img = FeedVC.imageCach.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, img: img)
            return cell
            
        }else{
            return PostCell()
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil {
            return 150
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImg.image = image
        
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func makePost(sender: AnyObject) {
        
    }
    
    
}
