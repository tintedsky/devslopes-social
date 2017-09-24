//
//  PostCell.swift
//  devslopes-social
//
//  Created by Hongbo Niu on 2017-09-18.
//  Copyright © 2017 Udemy. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg:  UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    var likesRef : DatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add a tapRecognizer to like image programmatically.
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }

    func configureCell(post: Post, img: UIImage? = nil){
        self.post = post
        self.caption.text =  post.caption
        self.likesLbl.text = "\(post.likes)"
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        if img != nil {
            self.postImg.image = img
        }else{
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024 , completion: { (data, err) in
                if err != nil{
                    print("JESSHB: Unable to download image from Firebase storage")
                }else{
                    print("JESSHB: Image downloaded from Firebase storage")
                    if let imageData = data, let img = UIImage(data: imageData) {
                        self.postImg.image = img
                        FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                    }
                }
            })
        }
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeImg.image = UIImage(named: "empty-heart")
            } else{
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    //In a closure, we need to put self before member variables.
    func likeTapped(sender: UITapGestureRecognizer){
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(like: true)
                self.likesRef.setValue(true)
            } else{
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(like: false)
                self.likesRef.removeValue()
            }
        })
    }
}
