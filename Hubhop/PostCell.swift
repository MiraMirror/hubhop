//
//  PostCell.swift
//  Hubhop
//
//  Created by Xuan Yang on 9/27/15.
//  Copyright © 2015 MiraCode. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    var request: Request?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func drawRect(rect: CGRect) {
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
    }

    func configureCell(post: Post, img: UIImage?){
        self.post = post
        
        self.descriptionTxt.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        if post.imageUrl != nil {
            
            if img != nil{
                self.showcaseImg.image = img
            } else{
                
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    
                    if err == nil {
                        let img = UIImage(data: data!)
                        self.showcaseImg.image = img
                        FeedVC.imageCach.setObject(img!, forKey: post.imageUrl!)
                    }
                    
                })
                
            }
            
        } else {
            self.showcaseImg.hidden = true
        }
        
    }

}
